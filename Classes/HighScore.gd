extends Resource


class_name HighScore


@export var score: int
@export var date_scored: String


func _init(_score: int = 0) -> void:
	score = _score
	date_scored = FoxyUtils.formatted_dt()
