extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var la : int 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func test():
	print("Test")
	pass


func _on_Enemy_body_entered(body: Node) -> void:
	if "Player" in body.name:
		#Player Dead Game Over
		pass
	if "Ball" in body.name:
		get_parent().remove_enemy(self)
		pass
	pass # Replace with function body.
