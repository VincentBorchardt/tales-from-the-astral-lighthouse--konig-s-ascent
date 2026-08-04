extends CharacterBody2D

signal movement_finished
signal laughing_finished
signal materialized


enum State {
	FLOAT,
	LAUGH
}


@export var movement_speed: float = 100.0
@export var movement_targets: Array[Node2D]
@export var navigation_agent: NavigationAgent2D

@onready var laugh_sound = $Laugh
@onready var animations = $AnimatedSprite2D

var state = State.FLOAT
var current_target_index := 0
var moving := false
var last_direction := Vector2.DOWN

func _ready() -> void:
	animations.play("float_sw")
	ready.connect(get_tree().current_scene.on_dsd_ready)

func make_invisible():
	visible = false

func materialize():
	visible = true
	animations.play("materialize")
	await animations.animation_finished
	materialized.emit()


func start_move():
	if movement_targets.is_empty():
		return

	current_target_index = 0
	move_to_next_target()


func move_to_next_target():
	if current_target_index >= movement_targets.size():
		moving = false
		velocity = Vector2.ZERO
		animations.play(get_float_animation())
		return

	moving = true

	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame

	var target = movement_targets[current_target_index]
	navigation_agent.target_position = target.global_position


func _physics_process(delta):
	match state:
		State.FLOAT:
			if moving:
				move_state()

		State.LAUGH:
			velocity = Vector2.ZERO


func move_state():
	var target = movement_targets[current_target_index]

	var distance = global_position.distance_to(target.global_position)

	if distance < 20:
		velocity = Vector2.ZERO
		moving = false

		current_target_index += 1

		animations.play(get_float_animation())
		movement_finished.emit()
		if GameplayManager.is_final_level == false:
			animations.play("demat_nw")
			await animations.animation_finished
			queue_free()
		return

	var next_path = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path)

	last_direction = direction

	animations.play(get_float_animation())

	velocity = direction * movement_speed
	move_and_slide()


func start_laugh():
	state = State.LAUGH
	velocity = Vector2.ZERO
	laugh_sound.play()
	animations.play("laugh")
	await animations.animation_finished

	state = State.FLOAT

	if moving or !GameplayManager.is_final_level:
		animations.play(get_float_animation())
		 
	laughing_finished.emit()

func get_float_animation() -> String:
	if last_direction.x > 0:
		if last_direction.y < 0:
			return "float_ne"
		else:
			return "float_se"
	else:
		if last_direction.y < 0:
			return "float_nw"
		else:
			return "float_sw"
