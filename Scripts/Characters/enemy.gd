extends CharacterBody2D

enum State {
	KNOCKBACK,
	SHOOT
}

var state = State.SHOOT

@export var knockback_speed = 1.5
@export var bullet_lag = .3
@export var bullet_scene: PackedScene
@onready var muzzle = $Marker2D

var npcs

func _ready():
	npcs = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	match state:
		State.KNOCKBACK:
			move_and_slide()
			var collision = move_and_collide(velocity)

			if collision:
				queue_free()


func take_hit(direction):
	velocity = direction * knockback_speed
	state = State.KNOCKBACK


func shoot():
	if npcs != null:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = muzzle.global_position
		bullet.direction = (npcs.global_position - muzzle.global_position).normalized() * bullet_lag
		bullet.rotation = bullet.direction.angle()


func _on_timer_timeout() -> void:
	if state == State.SHOOT:
		shoot()
