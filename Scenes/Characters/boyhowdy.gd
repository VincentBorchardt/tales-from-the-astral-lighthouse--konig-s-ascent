extends CharacterBody2D

enum State {
	KNOCKBACK,
	SHOOT,
	CONVO
}

signal boyhowdy_died
signal entered_range

var entered_range_once = false
var state = State.CONVO
var dead = false
@export var knockback_speed = 1.5
@export var bullet_lag : float = 0.3
@export var bullet_scene: PackedScene
@onready var timer = $Timer
@onready var muzzle = $Marker2D
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var enemy_anim = $AnimatedSprite2D
@onready var shadow = $Shadow
@onready var explode = $Explode
@onready var interaction_animation = $InteractAnimation
@onready var interaction_range = $InteractionRange

var player
var player_in_range = false
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if player_in_range and Input.is_action_just_pressed("advance_text"):
		var konig = get_parent().get_node("Konig")
		konig.start_attack()

func _physics_process(delta):
	match state:
		State.SHOOT:
			var direction = (player.global_position - global_position).normalized()
			enemy_anim.play(get_idle_animation(direction))
		State.KNOCKBACK:
			hurtbox.disabled = true
			var collision = move_and_collide(velocity)

			if collision:
				die()
		State.CONVO:
			return

func die():
	if dead:
		return
	dead = true
	velocity = Vector2.ZERO
	shadow.visible = false
	play_explode_sound()
	enemy_anim.play("boyhowdy_death")
	await enemy_anim.animation_finished
	boyhowdy_died.emit()
	queue_free()

func play_explode_sound():
	var pitch_max = 1
	var increase = GameplayManager.enemy_combo
	pitch_max += increase
	explode.pitch_scale = randf_range(pitch_max, pitch_max)
	explode.play()

func start_shooting():
	state = State.SHOOT
	timer.start()
	
func beg():
	state = State.CONVO
	interaction_range.monitoring = true
	timer.stop()

func take_hit(direction):
	velocity = direction * knockback_speed
	enemy_anim.play(get_knockback_animation(direction))
	interaction_range.monitoring = false
	interaction_animation.visible = false
	state = State.KNOCKBACK

func set_entered_range():
	entered_range_once = true

func get_knockback_animation(direction):
	return "boyhowdy_knockback"

func get_idle_animation(direction):
	return "boyhowdy_idle"

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	bullet.direction = (player.global_position - muzzle.global_position).normalized()

func _on_timer_timeout() -> void:
	if state == State.SHOOT:
		shoot()
		

func _on_interaction_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		interaction_animation.visible = true
		interaction_animation.play("interaction")
		if entered_range_once == false:
			emit_signal("entered_range")


func _on_interaction_range_body_exited(body: Node2D) -> void:
	player_in_range = false
	interaction_animation.visible = false
