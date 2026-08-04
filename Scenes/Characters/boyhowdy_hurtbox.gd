extends Area2D

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var enemy = get_parent()
	enemy.take_hit()
