extends Area2D

func _on_hitbox_area_entered(area: Area2D):
	var enemy = get_parent()

	if enemy.state != enemy.State.KNOCKBACK:
		return

	var other_enemy = area.get_parent()

	if other_enemy.is_in_group("enemy"):
		other_enemy.take_hit(enemy.velocity.normalized())
		Hitstop.stop(.1)

	enemy.die()
