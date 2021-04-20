extends KinematicBody2D
class_name EnemyParent

export var velocity : int = 0
export var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	velocity = 500
	direction = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	shoot_bullets()
	var collision : KinematicCollision2D = movement(_delta)
	if collision:
		bounce(collision)
	pass

func bounce(collision : KinematicCollision2D):
	if !(collision.collider is KinematicBody2D):
		#Boundaries
		direction = direction.bounce(collision.normal)
		pass  
	pass

func hit():
	get_parent().remove_enemy(self)
	pass

func movement(_delta: float) -> KinematicCollision2D:
	return move_and_collide(direction * velocity * _delta)

func test():
	print("This is called from the EnemyParent Script")
	pass

func shoot_bullets():

	pass
