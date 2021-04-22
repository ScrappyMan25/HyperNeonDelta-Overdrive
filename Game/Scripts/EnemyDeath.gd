extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func particle_emit(C : Color, pos : Vector2):
	position = pos
	$ParticlesEnd.wait_time = 1.5
	$ParticlesEnd.start()
	$EnemyParticles.modulate = C
	$Points.modulate = C
	$EnemyParticles.emitting = true
	$Points.emitting = true
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
