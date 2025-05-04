extends Node

signal create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
)

func emit_create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
) -> void:
	create_bullet.emit(pos, dir, speed, object_type)
