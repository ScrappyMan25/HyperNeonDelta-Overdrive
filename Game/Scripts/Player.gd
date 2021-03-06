extends KinematicBody2D

var Player_Health : int = 3
var score : int  = 0
var SoundScene : Node
var GameScene : Node
#Variables required for movement
var velocity : Vector2 = Vector2.ZERO

export(float) var ACCELERATION: float = 5000
export(float) var MAX_SPEED : float = 400
export(float) var FRICTION : float = 4000
var motion = Vector2()
var invulnerable = false

#for Dash
#var num_dash = 1
var can_dash : bool = true
var is_dashing : bool = false
export(float) var dash_cooldown : float = 1

export(float) var dash_speed : float = 1200
export(float) var dash_length : float = 0.1
var dash_direction : Vector2

func _ready():
	GameScene = get_parent()
	SoundScene = GameScene.get_node("SoundScene")
	pass

func _physics_process(delta):
	if is_dashing == true:
		velocity = move_and_slide(dash_direction)
#		is_dashing = false
	else:
		var axis = get_input_axis()
		if axis == Vector2.ZERO:
			apply_friction(ACCELERATION * delta)
		else:
			apply_movement(axis * ACCELERATION * delta)
		motion = move_and_slide(motion)
		velocity = move_and_slide(velocity)

func get_input_axis() -> Vector2: 
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	look_at(get_global_mouse_position())
	velocity = Vector2()
	#if dashing do dash
	#Dash Code
	if Input.is_action_just_pressed("ui_accept") and can_dash:#can_dash:
		dash()
	return axis.normalized()

func apply_friction(f):
	if motion.length() > f:
		motion -= motion.normalized() * f
	else:
		motion = Vector2.ZERO
	pass

func apply_movement(a):
	motion += a
	motion = motion.clamped(MAX_SPEED)
	if motion.length() > MAX_SPEED:
		motion = motion.normalized() * MAX_SPEED
	pass

func player_hit():
	if !invulnerable:
		invulnerable = true
		SoundScene.get_node("PlayerHit").play()
		$AnimatedSprite.show()
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play("default")
		$Sprite.modulate.a8 = 0
		get_parent().get_node("Camera2D").add_trauma(0.15)
		Player_Health -= 1
		if Player_Health < 0:
			get_parent().get_node("User Interface")._Game_Over()
			pass
	pass

func dash():
	can_dash = false
	is_dashing = true
#	num_dash -= 1
	SoundScene.get_node("Dash").play()
	$DashTimer.start(dash_length)
	$DashCooldownTimer.start(dash_cooldown)
	dash_direction = Vector2.RIGHT.rotated(rotation) * dash_speed


func _on_DashTimer_timeout() -> void: #how long dash lasts
	is_dashing = false
	pass # Replace with function body.

func _on_DashCooldownTimer_timeout() -> void:
	can_dash = true
	pass

func _on_AnimatedSprite_animation_finished() -> void:
	$AnimatedSprite.hide()
	$AnimatedSprite.stop()
	$Sprite.show()
	$Sprite.modulate.a8 = 255
	invulnerable = false
	pass # Replace with function body.

func _on_AnimatedSprite_frame_changed() -> void:
	if $AnimatedSprite.playing:
		$Sprite.visible = !$Sprite.visible
		$Sprite.modulate.a8 += 17
	pass # Replace with function body.
