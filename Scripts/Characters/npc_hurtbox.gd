extends Area2D

func _on_hurtbox_area_entered() -> void:
	print("ouch!")
	var npc = get_parent()
	
	npc.take_hit()
