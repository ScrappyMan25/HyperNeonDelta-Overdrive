extends EnemyParent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func test():
	print("This is called from the Enemy Script")
	pass

#func movement(_delta: float) -> KinematicCollision2D:
#	return move_and_collide(direction * velocity * _delta)

func shoot_bullets():
	print("pewpew")
	pass
