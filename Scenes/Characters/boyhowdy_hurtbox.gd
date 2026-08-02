extends Area2D

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var enemy = get_parent()

	var knockback = Vector2.UP

	enemy.take_hit(knockback)
