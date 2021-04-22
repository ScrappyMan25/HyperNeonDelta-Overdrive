extends CanvasLayer
var HighScore = 0
const filepath = "user://highscore.data"
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	$PauseMenu.hide()
	$GameOver.hide()
	updateScore(0)
	load_highscore()
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
	
func updateScore(score: int):
	$Score.text = score as String
	if score > HighScore:
		$GameOver/NewHighScoreLabel.show()
		$GameOver/Result.hide()
		$GameOver/NewHighScoreLabel.text = "NEW HIGH SCORE: "+ score as String
		HighScore = score
		save_highscore()
	else:
		$GameOver/NewHighScoreLabel.hide()
		$GameOver/Result.show()
		$GameOver/Result/FinalScore.text = "SCORE: "+score as String
		$GameOver/Result/HighScore.text = "HIGH SCORE: "+ HighScore as String
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
