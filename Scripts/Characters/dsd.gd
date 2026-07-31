extends CharacterBody2D


@export var movement_speed = 100.0
@export var movement_target : Node2D
@export var navigation_agent : NavigationAgent2D

@export var conversation : Array[Message]

@onready var body_animations = $Animation


func start_move():
	print("Starting NPC movement")
	move_to_booth()

func move_state():
	var distance = global_position.distance_to(movement_target.global_position)

	if distance < 20:
		velocity = Vector2.ZERO
	
	var next_path: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_path)

	velocity = direction * movement_speed
	move_and_slide()
	body_animations.play("walk")




func move_to_booth():

	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")

	
func actor_setup():
	await get_tree().physics_frame
	navigation_agent.target_position = movement_target.global_position
	
