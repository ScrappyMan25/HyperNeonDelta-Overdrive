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
var animated_sprite
var sprite

var is_ready : bool = false

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	velocity = 200
	direction = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	shoot_timer = get_node("ShootTimer")
	rotator = get_node("Rotator")
	animated_sprite = get_node("AnimatedSprite")
	sprite = get_node("Sprite")
	sprite.show()
	sprite.modulate.a8 = 0
	
	var step = 2 * PI / spawn_point_count #sets equal distance between each spawn point
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i) #rotating by the equal distance of step
		spawn_point.position = pos #sets where spawn point where bullet will spawn
		spawn_point.rotation = pos.angle() #set the angle spawn point which in turn will be used for the bullet angle
		rotator.add_child(spawn_point) #Bullets will rotate with the rotator
	
	shoot_timer.connect("timeout", self, "_on_ShootTimer_timeout")
	shoot_timer.wait_time = shooter_timer_wait_time
	
	animated_sprite.play("default")
	animated_sprite.connect("animation_finished", self, "_on_Animation_finished")
	animated_sprite.connect("frame_changed", self, "_on_Animation_Frame_Changed")
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
	if is_ready:
		emit_signal("destroyed")
		queue_free()
	pass

func movement(_delta: float) -> KinematicCollision2D:
	if is_ready:
		return move_and_collide(direction * velocity * _delta)
	else:
		return move_and_collide(Vector2.ZERO)

func _on_ShootTimer_timeout() -> void:
	for s in rotator.get_children():
		var bullet = bullet_scene.instance() #create a bullet
		bullet.position = s.global_position 
		bullet.rotation = s.global_rotation
		bullet.get_node("Sprite").modulate = sprite.modulate
		get_parent().get_parent().get_node("Bullets").add_child(bullet) #add the bullet to the root
		#set bullet position and rotation to match spawn points

func _on_Animation_Frame_Changed():
	if !is_ready:
		sprite.modulate.a8 += 17
		sprite.visible = !sprite.visible
	pass

func _on_Animation_finished():
	get_parent().get_node("Timer").paused = false
	animated_sprite.hide()
	sprite.modulate.a8 = 255
	sprite.show()
	is_ready = true
	shoot_timer.start()
	pass
