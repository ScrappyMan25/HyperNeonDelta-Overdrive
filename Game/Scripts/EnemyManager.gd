extends Node2D

var Enemies = [
#	preload("res://Scenes/Enemy_1.tscn"),
#	preload("res://Scenes/Enemy_2.tscn"),
#	preload("res://Scenes/Enemy_3.tscn"),
#	preload("res://Scenes/Enemy_4.tscn"),
#	preload("res://Scenes/Enemy_5.tscn"),
#	preload("res://Scenes/Enemy_6.tscn"),
#	preload("res://Scenes/Enemy_7.tscn"),
#	preload("res://Scenes/Enemy_8.tscn"),
	preload("res://Scenes/Enemy_9.tscn")
	
]
var Player : KinematicBody2D
var count = 1
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	randomize()
	Enemies.shuffle()
	Player = get_parent().get_node("Player")
	add_enemy()
	pass # Replace with function body.

func add_enemy():
	while true:
		var t : Vector2 = Vector2(rand_range(-get_viewport_rect().size.x/2 + 10, get_viewport_rect().size.x/2 - 10), rand_range(-get_viewport_rect().size.y/2 +10, get_viewport_rect().size.y/2 - 10))
		if (t.x < Player.position.x + 5 || t.x < Player.position.x - 5) && (t.y < Player.position.y + 5 || t.x < Player.position.y - 5):
			Enemies.shuffle()
			var e = Enemies[0].instance()
			e.position = t
			e.connect("destroyed", self, "enemy_destroyed")
			call_deferred("add_child", e, true)
			break  
		pass
	pass

func enemy_destroyed():
	if get_child_count() == 1:
		count+=1
		for _i in range(count):
			add_enemy()
	pass
