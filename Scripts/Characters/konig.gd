extends CharacterBody2D

enum State {
	KNOCKBACK,
	ATTACK,
	MOVE,
	WARPING
}

signal konig_arrived
signal konig_left

@onready var hitbox = $Hitbox/CollisionShape2D
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var animations = $Animations
@onready var timer = $Knockback
@export var ACCELERATION  = 50
@export var FRICTION  = 20
@export var MOTION_SPEED = 40
@export var KNOCKBACK_SPEED = 100
@export var KNOCKBACK_TIME = 0.05

var state = State.WARPING
var knockback_velocity = Vector2.ZERO
var last_x_direction = 1
var last_y_direction = 1
var last_direction = Vector2(1, 0)

func _ready():
	hitbox.disabled = true

func _physics_process(delta):
	match state:
		State.MOVE:
			move_state(delta)
			
		State.KNOCKBACK:
			knockback_state()
			
		State.ATTACK:
			attack_state()

func move_state(delta):
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	var velocity_weight: float = delta * (ACCELERATION if motion.x or motion.y else FRICTION)
	animations.play(get_walk_animation())
	if motion.x != 0:
		last_x_direction = sign(motion.x)
	if motion.y != 0:
		last_y_direction = sign(motion.y)
	if motion != Vector2.ZERO:
		last_direction = motion.normalized()
	else:
		update_idle()
	if Input.is_action_just_pressed("attack"):
		start_attack()
	velocity = velocity.lerp(motion, velocity_weight * delta)
	move_and_slide()


func knockback_state():
	if state == State.ATTACK:
		return
	velocity = knockback_velocity
	move_and_slide()
	hitbox.disabled = true


func _on_timer_timeout():
	state = State.MOVE
	velocity = Vector2.ZERO
	timer.stop()

func take_hit(direction):
	if state == State.MOVE:
		state = State.KNOCKBACK
		knockback_velocity = direction.normalized() * KNOCKBACK_SPEED
		timer.start(KNOCKBACK_TIME)


func start_attack():
	state = State.ATTACK
	update_hitbox_direction()
	hitbox.disabled = false
	animations.play(get_attack_animation())

func attack_state():
	velocity = Vector2.ZERO
	move_and_slide()

func get_attack_animation() -> String:
	if last_x_direction > 0:
		if last_y_direction < 0:
			return "attack_ne"
		else:
			return "attack_se"

	else:
		if last_y_direction < 0:
			return "attack_nw"
		else:
			return "attack_sw"

func warp_in():
	print("triggering warp in")
	visible = true
	state = State.WARPING
	animations.play("warp_in")

func warp_out():
	state = State.WARPING
	# TODO HAVE THIS CHECK FOR DIRECTION!
	animations.play("warp_out_se")

func _on_animated_sprite_2d_animation_finished():
	match animations.animation:
		"warp_in":
			state = State.MOVE
			konig_arrived.emit()
		"warp_out_ne", "warp_out_nw", "warp_out_se", "warp_out_sw":
			konig_left.emit()
		_: # TODO should probably put all the attacks here explicitly
			hitbox.disabled = true
			if state == State.ATTACK:
				state = State.MOVE

func update_hitbox_direction():
	if last_x_direction > 0:
		if last_y_direction < 0:
			#ne
			hitbox.position = Vector2(9, 2)
			hitbox.rotation_degrees = 47.7
		else:
			#se
			hitbox.position = Vector2(8, 14)
			hitbox.rotation_degrees = 107.7

	else:
		#nw
		if last_y_direction < 0:
			hitbox.position = Vector2(-3, 7)
			hitbox.rotation_degrees = 127.7
		else:
		#sw
			hitbox.position = Vector2(-9, 7)
			hitbox.rotation_degrees = 252.8
			

func update_idle():
	var anim = get_attack_animation()
	animations.play(anim)
	animations.stop()
	animations.frame = 0

func get_walk_animation() -> String:
	if last_x_direction > 0:
		if last_y_direction < 0:
			return "walk_ne"
		else:
			return "walk_se"

	else:
		if last_y_direction < 0:
			return "walk_nw"
		else:
			return "walk_sw"

	#if dir.length() > 0:
		#last_direction = dir
		#update_animation("walk")
	#else:
		#update_animation("idle")
