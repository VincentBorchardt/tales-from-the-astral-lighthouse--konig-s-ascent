extends Area2D

@onready var animation = $AnimatedSprite2D

@export var SPEED := 100
var direction: Vector2 = Vector2.ZERO

func _process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	animation.play("pop")
	await animation.animation_finished
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animation.play("default")
