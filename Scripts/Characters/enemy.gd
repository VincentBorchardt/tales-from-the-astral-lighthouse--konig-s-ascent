extends CharacterBody2D

signal died

enum State {
	KNOCKBACK,
	SHOOT
}

var state = State.SHOOT

@export var knockback_speed = 1.5
@export var bullet_lag = .3
@export var bullet_scene: PackedScene
@onready var muzzle = $Marker2D
@onready var hurtbox = $Hurtbox/CollisionShape2D

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	match state:
		State.KNOCKBACK:
			hurtbox.disabled = true
			move_and_slide()
			var collision = move_and_collide(velocity)

			if collision:
				died.emit()
				queue_free()


func take_hit(direction):
	velocity = direction * knockback_speed
	state = State.KNOCKBACK


func shoot():
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = muzzle.global_position
		bullet.direction = (player.global_position - muzzle.global_position).normalized() * bullet_lag
		bullet.rotation = bullet.direction.angle()


func _on_timer_timeout() -> void:
	if state == State.SHOOT:
		shoot()
