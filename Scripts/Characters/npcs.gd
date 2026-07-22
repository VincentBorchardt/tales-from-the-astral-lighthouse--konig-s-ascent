extends CharacterBody2D

enum State {
	CONVO,
	IDLE
}

@export var health = 5
@onready var idle_anim = $Animation
var state = State.IDLE

func _physics_process(delta):
	match state:
		State.IDLE:
			idle_anim.play("idle")



func take_hit():
	print("taking health")
	health -= 1
	if health == 0:
		queue_free()
