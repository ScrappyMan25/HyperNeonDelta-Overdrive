extends CanvasLayer
var HighScore = 0
var EnemyManager_Timer : Timer
var Player

var SoundScene : Node
var GameScene : Node

var Game_is_over : bool = false

const filepath = "user://highscore.data"
# Called when the node enters the scene tree for the first time.
func _ready():
	GameScene = get_parent()
	SoundScene = GameScene.get_node("SoundScene")
	SoundScene.get_node("GameMusic").play()
	get_tree().paused = false
	$PauseMenu.hide()
	$GameOver.hide()
	$GameOverFade.hide()
	updateScore(0)
	load_highscore()
	EnemyManager_Timer = get_parent().get_node("EnemyManager/Timer")
	Player = get_parent().get_node("Player")
	pass # Replace with function body.

func load_highscore():
	var file = File.new()
	if not file.file_exists(filepath):
		return
	file.open(filepath, File.READ)
	HighScore = file.get_var()
	file.close()
	pass

func save_highscore():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(HighScore)
	file.close()
	pass

func _process(_delta: float) -> void:
	if !Game_is_over:
		$Timer/Time.text = stepify(EnemyManager_Timer.time_left,0.01) as String
		if EnemyManager_Timer.paused:
			$Timer/ClockAnimation.stop()
		else:
			$Timer/ClockAnimation.play()
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_Continue_pressed()
		else:
			_Pause_Game()
	updateScore(Player.score)
	updateHealth(Player.Player_Health)
	pass

func updateHealth(health: int):
	$PlayerHealth/PlayerHealthLabel.text = health as String
	pass

func updateScore(score: int):
	$Score.text = score as String
	if score > HighScore && Game_is_over:
		$GameOver/NewHighScoreLabel.show()
		$GameOver/Result.hide()
		$GameOver/NewHighScoreLabel.text = "NEW HIGH SCORE: "+ score as String
		HighScore = score
		save_highscore()
	elif score < HighScore && Game_is_over:
		$GameOver/NewHighScoreLabel.hide()
		$GameOver/Result.show()
		$GameOver/Result/FinalScore.text = "SCORE: "+ score as String
		$GameOver/Result/HighScore.text = "HIGH SCORE: "+ HighScore as String
	pass

func _Game_Over():
	Game_is_over = true
	$GameOverFade.show()
	$GameOverFade/FadeIn.play("GameOverFade")
	$Timer/ClockAnimation.stop()
	get_tree().paused = true
	pass

func _Pause_Game():
	get_tree().paused = true
	$PauseMenu.show()
	pass

func _on_Continue_pressed():
	get_tree().paused = false
	$PauseMenu.hide()
	pass # Replace with function body.


func _on_Restart_pressed():
	var err = get_tree().reload_current_scene()
	if err:
		print(err)
	get_tree().paused = false
	pass # Replace with function body.


func _on_Exit_pressed():
	var err = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	if err:
		print(err)
	get_tree().paused = false
	pass # Replace with function body.


func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_FadeIn_animation_finished(_anim_name):
	get_parent().get_node("Camera2D").zoom = Vector2(1.0,1.0)
	get_parent().get_node("Camera2D").rotation = 0
	get_parent().get_node("Camera2D").offset = Vector2.ZERO
	$PlayerHealth.hide()
	$GameOverFade.hide()
	$Timer.queue_free()
	get_parent().get_node("BG/Background").hide()
	get_parent().get_node("Player").hide()
	get_parent().get_node("EnemyManager").queue_free()
	get_parent().get_node("Bullets").queue_free()
	get_parent().get_node("Particles").queue_free()
	for ball in get_parent().get_children():
		if "Ball" in ball.name:
			ball.queue_free()
	get_parent().get_node("BG/ArenaBorder").modulate = Color("dcff0101")
	
	$Score.hide()
	$Timer.hide()
	$PauseMenu.hide()
	$GameOver.show()
	pass # Replace with function body.
