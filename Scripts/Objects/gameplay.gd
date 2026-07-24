extends Node2D

var wave_animations = [
	"wave_1",
	"wave_2",
	"wave_3"
]

@export var waves: Array[PackedScene]
@export var booth_scene: PackedScene

@onready var booth_spawn = $BoothSpawn
@onready var wave_timer = $WaveTimer
@onready var wave_animation = $WaveAnimation


var current_wave := -1
var current_wave_scene: Node2D
var enemies_remaining := 0
var current_wave_animation = 0

func _ready():
	wave_timer.one_shot = true
	wave_timer.timeout.connect(play_wave_animation)

	play_wave_animation()

func play_wave_animation():
	if current_wave <= waves.size() -1:
		print("starting next wave")
		wave_animation.visible = true
		wave_animation.play(wave_animations[current_wave_animation])
		current_wave_animation += 1
	else:
		start_next_wave()
#TODO: set everything here that needs to be at the start of a round or when all waves or finished
func start_next_wave():
	wave_animation.visible = false
	current_wave += 1

	#TODO: this is where end of round stuff happens
	if current_wave >= waves.size():
		print("all waves complete")
		var booth = booth_scene.instantiate()
		booth.global_position = booth_spawn.global_position
		add_child(booth)
		return

	current_wave_scene = waves[current_wave].instantiate()
	add_child(current_wave_scene)

	enemies_remaining = current_wave_scene.enemy_count

	print("new wave")


func enemy_spawned(enemy):
	enemy.died.connect(enemy_died)


func enemy_died():
	enemies_remaining -= 1
	print("enemies remaining:", enemies_remaining)

	if enemies_remaining <= 0:
		wave_complete()


func wave_complete():
	print("wave complete")
	current_wave_scene.queue_free()
	wave_timer.start()


# TODO If we're creating NPCs via code somehow, this will need to be connected via code
func _on_npcs_start_npc_conversation(messages: Array[Message]) -> void:
	#TODO pause the gameplay scene somehow; look into this
	$CutsceneOverlay.start_cutscene(messages)


func _on_cutscene_overlay_cutscene_ended() -> void:
	# TODO unpause the gameplay
	# TODO send the NPC to the booth--needs a way to tell that,
	# maybe with something sent in the first signal?
	pass # Replace with function body.
