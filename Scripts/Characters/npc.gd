class_name Npc extends CharacterBody2D

enum State {
	MOVE,
	CONVO,
	IDLE,
	HURT,
	DEAD
}

signal start_npc_conversation(messages)
signal npc_died(npc)

@export var movement_speed = 100.0
@export var movement_target : Node2D
@export var navigation_agent : NavigationAgent2D

@export var conversation : Array[Message]

@onready var body_animations = $Animation
@onready var convo_anim = $Convo
@onready var health_marker = $HealthMarker
@onready var hurtbox = $Hurtbox

var state = State.IDLE:
	set(newState):
		state = newState
		match newState:
			State.IDLE:
				body_animations.play("idle")
			State.HURT:
				body_animations.play("hurt")
			State.DEAD:
				body_animations.play("death")
			_:
				pass
var player_in_range = false
var health = 3:
	set(amount):
		health = amount
		match amount:
			3:
				health_marker.play("full")
			2:
				health_marker.play("mid")
			1:
				health_marker.play("low")
			0:
				health_marker.visible = false
				npc_died.emit(self)
				state = State.DEAD
			_:
				pass

func _ready():
	health_marker.play("full")
	state = State.IDLE

func _input(event: InputEvent) -> void:
	if player_in_range and Input.is_action_just_pressed("advance_text"):
		state = State.MOVE
		player_in_range = false
		convo_anim.visible = false
		start_npc_conversation.emit(conversation)

func _physics_process(delta):
	if state == State.MOVE:
		move_state()

func start_move():
	print("Starting NPC movement")
	move_to_booth()

func move_state():
	var distance = global_position.distance_to(movement_target.global_position)

	if distance < 20:
		velocity = Vector2.ZERO
		state = State.IDLE
		body_animations.play("warp")
		return
	
	var next_path: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_path)

	velocity = direction * movement_speed
	move_and_slide()
	body_animations.play("walk")

func tutorial_wave():
	hurtbox.monitoring = false
	

func end_of_wave():
	health_marker.visible = false
	state = State.CONVO

func move_to_booth():
	state = State.MOVE
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")

	
func actor_setup():
	await get_tree().physics_frame
	navigation_agent.target_position = movement_target.global_position
	

func take_hit():
	print("taking health")
	state = State.HURT
	health -= 1

func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and state == State.CONVO:
		print("entered NPC area")
		player_in_range = true
		convo_anim.visible = true
		convo_anim.play("convo")

func _on_interact_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and state == State.CONVO:
		player_in_range = false
		convo_anim.visible = false

func _on_animation_animation_finished() -> void:
	match body_animations.animation:
		"hurt":
			state = State.IDLE
		"death":
			queue_free()
		"warp":
			queue_free()
