extends Control

@onready var highscores_container: GridContainer = $MarginContainer/HighscoresContainer

@onready var press_space_label: Label = $VBoxContainer/PressSpaceLabel
@onready var press_a_label: Label = $VBoxContainer/PressALabel
@onready var controller_detected_label: Label = $"VBoxContainer/ControllerDetected]Label"

const HIGHSCORE_DISPLAY = preload("res://Scenes/HighscoreDisplay/HighscoreDisplay.tscn")

func _ready() -> void:
	get_tree().paused = false
	load_highscores()
	Input.connect("joy_connection_changed", _on_joy_connection_changed)
	if Input.get_connected_joypads().size() > 0:
		show_controls_guide(true)

func _on_joy_connection_changed(device_id: int, connected: bool):
	show_controls_guide(connected)

func show_controls_guide(is_gamepad: bool) -> void:
	press_space_label.visible = !is_gamepad
	press_a_label.visible = is_gamepad
	
	if is_gamepad: 
		controller_detected_label.show()
	else:
		controller_detected_label.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.load_next_level()

func load_highscores() -> void:
	var highscores: Array[HighScore] = GameManager.high_scores.get_scores_list()
	
	for highscore in highscores:
		var highscore_display = HIGHSCORE_DISPLAY.instantiate()
		highscore_display.setup(highscore)
		highscores_container.add_child(highscore_display)
