extends PathFollow2D

@export var speed: float = 50.0
@export var spin_speed: float = 360


func _process(delta: float) -> void:
	progress += speed * delta
	rotation_degrees += delta * spin_speed
