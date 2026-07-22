extends CharacterBody2D

enum State {
	MOVE,
	CONVO,
	IDLE
}
@export var movement_speed = 100.0
@export var movement_target : Node2D
@export var navigation_agent : NavigationAgent2D
@export var health = 5
@onready var idle_anim = $Animation
var state = State.IDLE

func _physics_process(delta):
	match state:
		State.IDLE:
			idle_state()
		State.MOVE:
			move_state()
		State.MOVE:
			convo_state()

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

func idle_state():
	idle_anim.play("idle")

func convo_state():
	return

func move_to_booth():
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	
func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target.position)
	
func set_movement_target(target_point: Vector2):
	navigation_agent.target_position = target_point
	state = State.MOVE

func take_hit():
	print("taking health")
	health -= 1
	if health == 0:
		queue_free()
