extends Node

@export var life_time: float = 20.0

func _ready() -> void:
	await get_tree().create_timer(life_time).timeout
	Callable(get_parent().queue_free).call_deferred()
