extends EnemyParent

const bullet_scene = preload("res://Scenes/Bullet.tscn")
onready var shoot_timer = $ShootTimer
onready var rotator = $Rotator

export(int) var rotate_speed: int = 100
export(float) var shooter_timer_wait_time: float = 0.2
export(int) var spawn_point_count: int = 2
export(int) var radius = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	var step = 2 * PI / spawn_point_count #sets equal distance between each spawn point
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i) #rotating by the equal distance of step
		spawn_point.position = pos #sets where spawn point where bullet will spawn
		spawn_point.rotation = pos.angle() #set the angle spawn point which in turn will be used for the bullet angle
		rotator.add_child(spawn_point) #Bullets will rotate with the rotator

	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()
	
func _process(delta: float) -> void:
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta #converts working with PI to 360 degrees
	rotator.rotation_degrees = fmod(new_rotation,360)
	
func test():
	print("This is called from the Enemy Script")
	pass

#func movement(_delta: float) -> KinematicCollision2D:
#	return move_and_collide(direction * velocity * _delta)

func shoot_bullets():
#	print("pewpew")
	pass


func _on_ShootTimer_timeout() -> void:
	for s in rotator.get_children():
		var bullet = bullet_scene.instance() #create a bullet
		get_tree().root.add_child(bullet) #add the bullet to the root
		#set bullet position and rotation to match spawn points
		bullet.position = s.global_position 
		bullet.rotation = s.global_rotation
