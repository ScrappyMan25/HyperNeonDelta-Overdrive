extends Area2D

func _on_Bullet_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.call_deferred("player_hit")
		pass
	elif "Enemy" in body.name:
		pass
	else:
		queue_free()
	pass # Replace with function body.
