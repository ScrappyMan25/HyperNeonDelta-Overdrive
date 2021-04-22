extends Control

var scene_to_load : PackedScene
var GameScene : PackedScene = preload("res://Scenes/Main.tscn")

func _ready():
	get_tree().paused = false
	$TitleScreenMusic.play()
	pass # Replace with function body.


func _on_Play_pressed():
	$Select.play()
	scene_to_load = GameScene
	$FadeIn.show()
	$FadeIn/AnimationPlayer.play("FadeIn")
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
	var err = get_tree().change_scene_to(scene_to_load)
	if err:
		print(err)
	pass # Replace with function body.
