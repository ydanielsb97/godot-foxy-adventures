extends VBoxContainer

class_name HighscoreDisplayItem

@onready var score_label: Label = $ScoreLabel
@onready var date_label: Label = $DateLabel

var _highscore: HighScore

func _ready() -> void:
	start_fading()
	set_label()

func setup(highscore: HighScore) -> void:
	_highscore = highscore

func start_fading() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color("#ffffff", 1.0), 1)

func set_label() -> void:
	score_label.text = "%05d" % _highscore.score
	date_label.text = _highscore.date_scored
