extends AnimatedSprite2D

@onready var sound: AudioStreamPlayer2D = $Sound

func _ready() -> void:
	sound.play()

func _on_animation_finished() -> void:
	queue_free()
