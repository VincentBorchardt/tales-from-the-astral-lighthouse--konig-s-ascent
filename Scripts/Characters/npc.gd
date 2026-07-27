class_name Npc extends CharacterBody2D

enum State {
	MOVE,
	CONVO,
	IDLE,
	HURT,
	DEAD
}

# TODO call this when you talk to the NPC
signal start_npc_conversation(messages)

@export var movement_speed = 100.0
@export var movement_target : Node2D
@export var navigation_agent : NavigationAgent2D

@export var conversation : Array[Message]

@onready var body_animations = $Animation
@onready var convo_anim = $Convo
@onready var health_marker = $HealthMarker

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
				state = State.DEAD
			_:
				pass

func _ready():
	health_marker.play("full")
	state = State.IDLE

# TODO remove this, it's a bad design pattern
func _physics_process(delta):
	match state:
		State.CONVO:
			convo_state()
		_:
			pass

func start_move():
		move_to_booth()

func move_state():
	if navigation_agent.is_navigation_finished():
			state = State.IDLE
	var current_position: Vector2 = global_position
	var next_path: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = next_path - current_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	velocity = new_velocity
	move_and_slide()


func convo_state():
	if player_in_range and Input.is_action_just_pressed("advance_text"):
		state = State.MOVE
		start_npc_conversation.emit(conversation)

func end_of_wave():
	health_marker.visible = false
	state = State.CONVO

func move_to_booth():
	body_animations.play("walk")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target.position)
	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	move_state()

func take_hit():
	print("taking health")
	state = State.HURT
	health -= 1

func _on_interact_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and state == State.CONVO:
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
