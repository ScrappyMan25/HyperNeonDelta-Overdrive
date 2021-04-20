extends KinematicBody2D
class_name EnemyParent

const bullet_scene = preload("res://Scenes/Bullet.tscn")

export var velocity : int = 0
export var direction : Vector2 = Vector2.ZERO


export(int) var rotate_speed: int = 100
export(float) var shooter_timer_wait_time: float = 0.2
export(int) var spawn_point_count: int = 2
export(int) var radius = 100

var shoot_timer
var rotator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	velocity = 500
	direction = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	shoot_timer = get_node("ShootTimer")
	rotator = get_node("Rotator")
	
	var step = 2 * PI / spawn_point_count #sets equal distance between each spawn point
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i) #rotating by the equal distance of step
		spawn_point.position = pos #sets where spawn point where bullet will spawn
		spawn_point.rotation = pos.angle() #set the angle spawn point which in turn will be used for the bullet angle
		rotator.add_child(spawn_point) #Bullets will rotate with the rotator
	
	shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var collision : KinematicCollision2D = movement(_delta)
	if collision:
		bounce(collision)
		
	var new_rotation = rotator.rotation_degrees + rotate_speed * _delta #converts working with PI to 360 degrees
	rotator.rotation_degrees = fmod(new_rotation,360)	
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

func _on_ShootTimer_timeout() -> void:
	for s in rotator.get_children():
		var bullet = bullet_scene.instance() #create a bullet
		get_tree().root.add_child(bullet) #add the bullet to the root
		#set bullet position and rotation to match spawn points
		bullet.position = s.global_position 
		bullet.rotation = s.global_rotation
