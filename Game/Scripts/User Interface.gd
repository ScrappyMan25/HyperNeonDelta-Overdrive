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
		$Time.text = "Time: " + stepify(EnemyManager_Timer.time_left,0.01) as String
	updateScore(Player.score)
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
	get_parent().get_node("BG/Background").hide()
	get_parent().get_node("Player").hide()
	get_parent().get_node("EnemyManager").queue_free()
	get_parent().get_node("Ball").queue_free()
	get_parent().get_node("Trail").hide()
	get_parent().get_node("Bullets").queue_free()
	
	get_parent().get_node("BG/ArenaBorder").modulate = Color("dcff0101")
	
	get_tree().paused = true
	$Score.hide()
	$Time.hide()
	$PauseButton.hide()
	$PauseMenu.hide()
	$GameOver.show()
	pass

func _on_PauseButton_pressed():
	get_tree().paused = true
	$PauseMenu.show()
	pass # Replace with function body.


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
