extends CharacterBody2D

signal died

enum State {
	KNOCKBACK,
	SHOOT
}

var state = State.SHOOT

@export var knockback_speed = 1.5
@export var bullet_lag : float = 0.3
@export var bullet_scene: PackedScene
@onready var muzzle = $Marker2D
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var enemy_anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var shadow = $Shadow
@onready var explode = $Explode

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	match state:
		State.SHOOT:
			var direction = (player.global_position - global_position).normalized()
			enemy_anim.play(get_idle_animation(direction))
		State.KNOCKBACK:
			hurtbox.disabled = true
			hitbox.disabled = false
			var collision = move_and_collide(velocity)

			if collision:
				die()

func die():
	velocity = Vector2.ZERO
	shadow.visible = false
	GameplayManager.increase_combo()
	play_explode_sound()
	enemy_anim.play("enemy_death")
	await enemy_anim.animation_finished
	died.emit()
	queue_free()

func play_explode_sound():
	var pitch_max = 1
	var increase = GameplayManager.enemy_combo
	pitch_max += increase
	explode.pitch_scale = randf_range(pitch_max, pitch_max)
	explode.play()



func take_hit(direction):
	velocity = direction * knockback_speed
	enemy_anim.play(get_knockback_animation(direction))
	state = State.KNOCKBACK

func get_knockback_animation(direction):
	if direction.x >= 0:
		if direction.y < 0:
			return "enemy_punched_sw"
		else:
			return "enemy_punched_nw"
	else:
		if direction.y < 0:
			return "enemy_punched_se"
		else:
			return "enemy_punched_ne"

func get_idle_animation(direction):
	if direction.x >= 0:
		if direction.y < 0:
			return "enemy_base_ne"
		else:
			return "enemy_base_se"
	else:
		if direction.y < 0:
			return "enemy_base_nw"
		else:
			return "enemy_base_sw"

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	bullet.direction = (player.global_position - muzzle.global_position).normalized() * bullet_lag


func _on_timer_timeout() -> void:
	if state == State.SHOOT:
		shoot()
