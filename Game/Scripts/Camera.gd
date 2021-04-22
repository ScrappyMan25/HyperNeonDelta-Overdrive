extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

var ScreenShake : Dictionary = {
	"decay" : 0.8,
	"max_offset" : Vector2(100,75),
	"max_roll" : 0.1,
	"trauma" : 0.0,
	"trauma_power" : 2
}


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#	Noise Setup
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	pass # Replace with function body.


func _process(delta: float) -> void:
	if ScreenShake.trauma:
		ScreenShake.trauma = max(ScreenShake.trauma - ScreenShake.decay * delta, 0)
		shake()
		pass
	pass

func add_trauma(amount) -> void:
	ScreenShake.trauma = min(ScreenShake.trauma + amount, 1.0)
	pass

func shake():
	var amount = pow(ScreenShake.trauma, ScreenShake.trauma_power)
	noise_y += 1
	rotation = ScreenShake.max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = ScreenShake.max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = ScreenShake.max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	pass
