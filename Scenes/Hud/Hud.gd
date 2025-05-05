extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel

var _score: int = 0

func _ready() -> void:
	_score = GameManager.cached_score
	update_score_label()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		GameManager.try_add_new_score(_score)
		GameManager.load_main()

func _enter_tree() -> void:
	SignalHub.scored.connect(on_scored)
	
func on_scored(points: int) -> void:
	_score += points
	update_score_label()

func update_score_label() -> void:
	score_label.text = "%05d" % _score
