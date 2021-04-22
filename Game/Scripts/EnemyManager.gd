extends Node2D

var Enemies = [
	preload("res://Scenes/Enemy_1.tscn"),
	preload("res://Scenes/Enemy_2.tscn"),
	preload("res://Scenes/Enemy_3.tscn"),
	preload("res://Scenes/Enemy_4.tscn"),
	preload("res://Scenes/Enemy_5.tscn"),
	preload("res://Scenes/Enemy_6.tscn"),
	preload("res://Scenes/Enemy_7.tscn"),
	preload("res://Scenes/Enemy_8.tscn"),
	preload("res://Scenes/Enemy_9.tscn")
	
]
var Player : KinematicBody2D
var count = 1

var Ball = preload("res://Scenes/Ball.tscn")

var top_left : Vector2
var bottom_right : Vector2

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	randomize()
	Enemies.shuffle()
	Player = get_parent().get_node("Player")
	add_enemy()
	$Timer.start()
	top_left = get_parent().get_node("TopLeft").position
	bottom_right = get_parent().get_node("BottomRight").position
	pass # Replace with function body.

func add_enemy():
	$Timer.paused = true
	while true:
		randomize()
		var t : Vector2 = Vector2(rand_range(top_left.x + 10, bottom_right.x - 10), rand_range(top_left.y + 10, bottom_right.y - 10))
		if (t.x < Player.position.x - 15 || t.x > Player.position.x + 15) && (t.y < Player.position.y - 15 || t.x > Player.position.y + 15):
			Enemies.shuffle()
			var e = Enemies[0].instance()
			e.position = t
			e.connect("destroyed", self, "enemy_destroyed")
			call_deferred("add_child", e, true)
			break  
		pass
	pass

func enemy_destroyed():
	$Timer.wait_time = $Timer.time_left + 1
	$Timer.start()
	Player.score += 100
	if get_child_count() == 2:
		Player.score += 10 * $Timer.time_left
		$Timer.wait_time = 10.0
		$Timer.start()
		count+=1
#		Extra Ball and life
		if count % 7 == 0:
			Player.Player_Health += 1
			var b = Ball.instance()
			b.set_deferred("velocity", b.VELOCITY)
			get_parent().call_deferred("add_child", b, true)

		for _i in range(count):
			add_enemy()
	pass


func _on_Timer_timeout() -> void:
	get_parent().get_node("User Interface")._Game_Over()
	pass # Replace with function body.
