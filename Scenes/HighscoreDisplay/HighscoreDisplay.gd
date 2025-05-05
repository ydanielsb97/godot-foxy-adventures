extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_fading()

func start_fading() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color("#ffffff", 1.0), 1)
