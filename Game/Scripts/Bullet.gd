extends Area2D

export(int) var speed: int = 100

func _process(delta):
	position += transform.x * speed * delta
	
func _onKillTimer_timeout() -> void:
		queue_free() #destroys bullet to save on memory


func _on_Bullet_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.call_deferred("player_hit")
		pass
	elif "Enemy" in body.name:
		pass
	else:
		queue_free()
	pass # Replace with function body.

