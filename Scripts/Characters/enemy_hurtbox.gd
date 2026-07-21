extends Area2D

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var enemy = get_parent()
	
	var knockback = (enemy.global_position - area.global_position).normalized()

	if knockback.x >= 0:
		knockback.x = 64
	else:
		knockback.x = -64
	
	if knockback.y >= 0:
		knockback.y = 32
	else:
		knockback.y = -32
	
	knockback = knockback.normalized()
	
	enemy.take_hit(knockback)
