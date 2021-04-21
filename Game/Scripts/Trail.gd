extends Node

var target
export var trailLength = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent().get_node("Ball")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Line2D.add_point(target.position)
	if $Line2D.get_point_count() > trailLength:
		$Line2D.remove_point(0)
	pass
