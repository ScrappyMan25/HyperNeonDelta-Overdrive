extends KinematicBody2D

#Variable to declare the type of User Device - Dynamic
const KEYBOARD = 0
const CONTROLLER = 1
const MOBILE = 1
var InputDevice

var Score : int = 0

#Variables required for movement
var speed : float = 400
var velocity : Vector2 = Vector2.ZERO
var friction = 0.0001
var acceleration = 0.001

#for Dash
var num_dash = 1
var can_dash : bool = true
var is_dashing : bool = false
var dash_speed = 2000
var dash_length = 0.1
var dash_direction : Vector2

func _physics_process(_delta: float) -> void:
	get_input()
	if is_dashing:
		velocity = move_and_slide(dash_direction)
#		is_dashing = false
	else:
		velocity = move_and_slide(velocity)
	pass

func get_input() -> void: 
	match(InputDevice):
		KEYBOARD:
			look_at(get_global_mouse_position())
			velocity = Vector2()
			pass
		CONTROLLER:
			pass
		MOBILE:
			pass
#	return input
	#Dash Code
	if Input.is_action_just_pressed("ui_accept") and !is_dashing:#can_dash:
		is_dashing = true
		num_dash -= 1
		$DashTimer.start(dash_length)
		if Input.is_action_pressed("ui_down"):
			dash_direction = Vector2.RIGHT.rotated(rotation + 135) * dash_speed
		else:
			dash_direction = Vector2.RIGHT.rotated(rotation) * dash_speed
	else:
		pass
	pass

func _input(event):
	if(event is InputEventKey or event is InputEventMouseMotion):
		InputDevice = KEYBOARD
		pass
	elif(event is InputEventJoypadButton || event is InputEventJoypadMotion):
		InputDevice = CONTROLLER
		pass
	elif(event is InputEventScreenTouch):
		InputDevice = MOBILE
		pass
pass

func player_hit():
	print("Player_hit")
	pass

func _on_DashTimer_timeout() -> void:
	is_dashing = false
	pass # Replace with function body.
