extends KinematicBody2D

export (int) var velocity : int = 0
const VELOCITY : int = 2500
var direction : Vector2 = Vector2.ZERO
var in_area : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(direction * velocity * delta)
	if collision:
		bounce(collision)
	pass

func _process(_delta: float) -> void:
	$Sprite.rotation = direction.angle() + PI/2
	if in_area:
		$Redirector/AOE.look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("ui_select"):
			Engine.time_scale = 1
			direction = (-position + get_global_mouse_position()).normalized()
			velocity = VELOCITY
			pass
		pass
	else:
		if velocity > 0:
			velocity -= 0.002 * velocity
	pass

func bounce(collision : KinematicCollision2D):
	if !(collision.collider is KinematicBody2D): 
			direction = direction.bounce(collision.normal)
	pass

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if "Player" in body.name :
		$Redirector/AOE.show()
		in_area = true
		Engine.time_scale = 0.05
		pass
	pass # Replace with function body.

func _on_PlayerDetector_body_exited(body: Node) -> void:
	if "Player" in body.name:
		$Redirector/AOE.hide()
		in_area = false
		Engine.time_scale = 1
		pass
	pass # Replace with function body.


func _on_EnemyHitDetector_body_entered(body: Node) -> void:
	if "Enemy" in body.name:
		body.hit()
	pass # Replace with function body.


func _on_EnemyHitDetector_area_entered(area: Area2D) -> void:
	if "Bullet" in area.name:
		area.queue_free()
		get_parent().get_node("Player").score += 1
		pass
	pass # Replace with function body.
