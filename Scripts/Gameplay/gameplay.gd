extends Node2D

var wave_animations = [
	"wave_1",
	"wave_2",
	"wave_3"
]
@export_group("Level Setup")
@export var waves: Array[PackedScene]
@export var next_level: PackedScene
@export var music : AudioStream

@export_group("NPC Conversations")
@export var npc_convo_0 : Array[Message]
@export var npc_convo_1 : Array[Message]
@export var npc_convo_2 : Array[Message]
@export var npc_convo_3 : Array[Message]
@export var npc_convo_4 : Array[Message]
@export var cameo_npc: Speaker


@export_group("Special Level Setup")
@export var is_tutorial = false
@export var is_final = false
@export var absorbed_bullet_threshold: int = 5

@onready var booth = $Booth
@onready var konig = $Konig
@onready var combo_timer = $ComboTimer
@onready var wave_timer = $WaveTimer
@onready var wave_animation = $WaveAnimation
@onready var wave_anim_player = $AnimationPlayer
@onready var cutscene_overlay = $CutsceneOverlay

var current_wave := -1
var current_wave_scene: Node2D
var enemies_remaining := 0
var current_wave_animation = 0
var in_calm_state = false
var npc_conversations: Array
var num_npcs: int
var current_npc = 0

var scripted_progression_count = 0
var absorbed_bullet_count: int = 0:
	set(new_bullet_count):
		absorbed_bullet_count = new_bullet_count
		print("absorbed bullet count = " + str(new_bullet_count))
		print("absorbed bullet threshold = " + str(absorbed_bullet_threshold))
		if new_bullet_count == absorbed_bullet_threshold:
			print("move to next part of sequence")
			scripted_progression_count += 1
			continue_scripted_sequence.call_deferred()

func _ready():
	npc_conversations = [npc_convo_0, npc_convo_1, npc_convo_2, npc_convo_3, npc_convo_4]
	num_npcs = get_tree().get_node_count_in_group("npcs")
	print("starting level now")
	in_calm_state = false
	print("Music resource:", music)
	MusicManager.play_music( music )
	wave_anim_player.play("floor_transition_in")
	await wave_anim_player.animation_finished
	combo_timer.one_shot = true
	combo_timer.timeout.connect(reset_combo)
	if wave_anim_player.has_animation("floor_number"):
		wave_anim_player.play("floor_number")
	booth.warp_in()
	

func play_wave_animation():
	if current_wave_animation >= waves.size():
		start_next_wave()
	else:
		print("starting next wave")
		wave_anim_player.play(wave_animations[current_wave_animation])
		current_wave_animation += 1

func continue_scripted_sequence():
	if is_tutorial:
		match scripted_progression_count:
			1:
				# Start the basic wave
				start_next_wave()
				konig.toggle_cutscene()
			2:
				scripted_progression_count += 1
				start_cutscene(StoryAutoload.tutorial_2)
			3:
				scripted_progression_count += 1
				konig.toggle_cutscene()
			4:
				scripted_progression_count += 1
				start_cutscene(StoryAutoload.tutorial_3)
			5:
				scripted_progression_count += 1
				in_calm_state = true
				get_tree().call_group("npcs", "end_of_wave")
			6:
				scripted_progression_count += 1
				booth.visible = true
				booth.warp_in()
			7:
				end_level()
	elif is_final:
		pass

#TODO: set everything here that needs to be at the start of a round or when all waves or finished
func start_next_wave():
	wave_animation.visible = false
	current_wave += 1

	#TODO: this is where end of round stuff happens
	if current_wave >= waves.size():
		print("all waves complete")
		in_calm_state = true
		booth.visible = true
		booth.warp_in()
		get_tree().call_group("npcs", "end_of_wave")
		return

	current_wave_scene = waves[current_wave].instantiate()
	add_child(current_wave_scene)

	enemies_remaining = current_wave_scene.enemy_count

	print("new wave")

func enemy_spawned(enemy):
	enemy.died.connect(enemy_died)

func reset_combo():
	print("reset combo")
	GameplayManager.reset_combo()

func enemy_died():
	enemies_remaining -= 1
	print("enemies remaining:", enemies_remaining)
	combo_timer.start()

	if enemies_remaining <= 0:
		wave_complete()

func end_level():
	if num_npcs > 0:
		StoryAutoload.append(cameo_npc)
		StoryAutoload.total_saved_npcs += num_npcs
	call_deferred("level_change")


func level_change():
	wave_anim_player.play("floor_transition_out")
	await wave_anim_player.animation_finished
	get_tree().change_scene_to_packed(next_level)

func wave_complete():
	print("wave complete")
	current_wave_scene.queue_free()
	if scripted_progression_count > 0:
		continue_scripted_sequence()
	wave_timer.start()



func _on_npcs_start_npc_conversation(messages: Variant) -> void:
	if in_calm_state:
		print(current_npc)
		var current_conversation = npc_conversations[current_npc]
		if current_conversation:
			current_npc += 1
			start_cutscene(current_conversation)
		else:
			print("tried to do a nonexistent conversation")

func start_cutscene(messages):
	get_tree().paused = true
	cutscene_overlay.start_cutscene(messages)

func _on_cutscene_overlay_cutscene_ended() -> void:
	print("ending cutscene")
	get_tree().paused = false
	if scripted_progression_count > 0:
		continue_scripted_sequence()


func _on_booth_player_entered() -> void:
	if in_calm_state:
		get_tree().call_group("npcs", "start_move")
		await wait_for_npcs()
		konig.warp_out()
	

func wait_for_npcs() -> void:
	while get_tree().get_nodes_in_group("npcs").size() > 0:
		await get_tree().process_frame

func _on_bullet_absorbed():
	print("absorbing bullet")
	if is_tutorial or is_final:
		print("adding to bullet count")
		absorbed_bullet_count += 1

func _on_booth_warp_in_finished() -> void:
	print("booth warp in finished")
	if in_calm_state:
		print("staying open in calm state")
		booth.stay_open()
	else:
		print("calling konig warp in")
		booth.stay_open()
		konig.warp_in()


func _on_booth_warp_out_finished() -> void:
	if in_calm_state:
		if is_tutorial:
			start_cutscene(StoryAutoload.tutorial_5)
		else:
			end_level()
	else:
		if is_tutorial:
			scripted_progression_count += 1
			start_cutscene(StoryAutoload.tutorial_1)
		elif is_final:
			pass
		else:
			wave_timer.one_shot = true
			wave_timer.timeout.connect(play_wave_animation)
			wave_timer.start(2)

# TODO these both might want short timers (like a second)
func _on_konig_arrived() -> void:
	booth.warp_out()

func _on_konig_left() -> void:
	booth.warp_out()


func _on_npc_died(npc: Variant) -> void:
	num_npcs -= 1
