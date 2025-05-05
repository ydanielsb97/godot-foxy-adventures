extends Area2D

@export var points: int = 2

@onready var anim: AnimatedSprite2D = $Anim
@onready var sound: AudioStreamPlayer2D = $Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ln: Array[String] = []
	for name in anim.sprite_frames.get_animation_names():
		ln.push_back(name)
	
	anim.animation = ln.pick_random()
	anim.play()

func _on_area_entered(area: Area2D) -> void:
	hide()
	set_deferred("monitoring", false)
	sound.play()
	SignalHub.emit_scored(points)


func _on_sound_finished() -> void:
	queue_free()
