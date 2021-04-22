extends KinematicBody2D

export (int) var velocity : int = 0
const VELOCITY : int = 2500
var direction : Vector2 = Vector2.ZERO
var in_area : bool = false
var SoundScene : Node
var GameScene : Node

var kill_animation = preload("res://Scenes/EnemyDeath.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameScene = get_parent()
	SoundScene = GameScene.get_node("SoundScene")
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
			SoundScene.get_node("PlayerShoot").play()
			direction = (-position + get_global_mouse_position()).normalized()
			velocity = VELOCITY
			get_parent().get_node("Camera2D").add_trauma(0.2)
			pass
		pass
	else:
		if velocity > 0:
			velocity -= 0.002 * velocity
	pass

func bounce(collision : KinematicCollision2D):
	if !(collision.collider is KinematicBody2D): 
			direction = direction.bounce(collision.normal)
			SoundScene.get_node("Ricochet").play()
	pass

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if "Player" in body.name :
		get_parent().get_node("SoundScene/GameMusic").pitch_scale = 0.5
		$Redirector/AOE.show()
		in_area = true
		Engine.time_scale = 0.05
		pass
	pass # Replace with function body.

func _on_PlayerDetector_body_exited(body: Node) -> void:
	if "Player" in body.name:
		get_parent().get_node("SoundScene/GameMusic").pitch_scale = 1
		$Redirector/AOE.hide()
		in_area = false
		Engine.time_scale = 1
		pass
	pass # Replace with function body.


func _on_EnemyHitDetector_body_entered(body: Node) -> void:
	if "Enemy" in body.name && body.is_ready:
		get_parent().get_node("Camera2D").add_trauma(0.10)
		SoundScene.get_node("DestroyEnemy").play()
		body.hit()
		var K = kill_animation.instance()
		K.particle_emit(body.modulate, position)
		get_parent().get_node("Particles").add_child(K)
	pass # Replace with function body.


func _on_EnemyHitDetector_area_entered(area: Area2D) -> void:
	if "Bullet" in area.name:
		area.queue_free()
		get_parent().get_node("Player").score += 1
		pass
	pass # Replace with function body.
