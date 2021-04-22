extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func particle_emit(C : Color, pos : Vector2):
	position = pos
	$ParticlesEnd.wait_time = 1.5
#	$EnemyParticles.emission_colors = C
	$Points.modulate = C
	$EnemyParticles.emitting = true
	$Points.emitting = true
	pass

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
