extends Control

func _ready():
	$SplashImage/AnimationPlayer.play("SplashScreenFade")
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	var err = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	if err:
		print(err)
	pass # Replace with function body.
