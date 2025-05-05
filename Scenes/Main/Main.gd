extends Control

@onready var highscores_container: GridContainer = $MarginContainer/HighscoresContainer

const HIGHSCORE_DISPLAY = preload("res://Scenes/HighscoreDisplay/HighscoreDisplay.tscn")

func _ready() -> void:
	get_tree().paused = false
	load_highscores()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.load_next_level()

func load_highscores() -> void:
	var highscores: Array[HighScore] = GameManager.high_scores.get_scores_list()
	
	for highscore in highscores:
		var highscore_display = HIGHSCORE_DISPLAY.instantiate()
		highscore_display.setup(highscore)
		highscores_container.add_child(highscore_display)
