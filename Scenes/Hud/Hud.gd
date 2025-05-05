extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MarginContainer/HBHearts

var _score: int = 0
var _hearts: Array

func _ready() -> void:
	_hearts = hb_hearts.get_children()
	_score = GameManager.cached_score
	update_score_label()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		GameManager.load_main()

func _enter_tree() -> void:
	SignalHub.scored.connect(on_scored)
	SignalHub.player_hit.connect(on_player_hit)

func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)

func on_scored(points: int) -> void:
	_score += points
	update_score_label()
	
func on_player_hit(lives: int, shake: bool) -> void:
	if lives < 0:
		level_over(false)
		return
	
	for index in range(_hearts.size() - lives):
		_hearts[index].modulate = "#000000"

func level_over(complete: bool) -> void:
	get_tree().paused = true

func update_score_label() -> void:
	score_label.text = "%05d" % _score
