extends Area2D

@export var SPEED := 100

var direction: Vector2 = Vector2.ZERO

func _process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()
