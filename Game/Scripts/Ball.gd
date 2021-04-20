extends KinematicBody2D

var velocity : float
var direction : Vector2 = Vector2.ZERO

var in_area : bool = false


var number_of_bounces = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = 200
	direction = Vector2(rand_range(-1,1), rand_range(-1,1)).normalized()
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(direction * velocity * number_of_bounces * delta)
	if number_of_bounces != 0:
		if collision:
			bounce(collision)
	pass

func _process(_delta: float) -> void:
	if in_area:
		$Redirector/AOE.look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("ui_select"):
			Engine.time_scale = 1
			number_of_bounces = 7
			direction = (-position + get_global_mouse_position()).normalized()
			pass
		pass
	pass

func bounce(collision : KinematicCollision2D):
	if !(collision.collider is KinematicBody2D): 
			direction = direction.bounce(collision.normal)
			number_of_bounces -= 0
	pass

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if "Player" in body.name:
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
