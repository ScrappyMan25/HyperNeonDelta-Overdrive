extends Node2D

var Enemy = preload("res://Scenes/Enemy.tscn")
var Player : KinematicBody2D
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	Player = get_parent().get_node("Player")
	add_enemy()
	pass # Replace with function body.

func add_enemy():
	while true:
		var t : Vector2 = Vector2(rand_range(0, get_viewport_rect().size.x - 10), rand_range(0, get_viewport_rect().size.y - 10))
		if (t.x < Player.position.x + 5 || t.x < Player.position.x - 5) && (t.y < Player.position.y + 5 || t.x < Player.position.y - 5):
			var e = Enemy.instance()
			e.position = t
			call_deferred("add_child", e, true)
			break  
		pass
	pass

func remove_enemy(enemy : Node):
	Player.Score += 10
	print(Player.Score)
	enemy.queue_free()
	add_enemy()
	pass

func _process(_delta: float) -> void:
	pass
