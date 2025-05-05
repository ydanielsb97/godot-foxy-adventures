extends Node

signal create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
)

signal create_object(pos: Vector2, object_type: Constants.ObjectType)

signal scored(points: int)

func emit_create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
) -> void:
	create_bullet.emit(pos, dir, speed, object_type)

func emit_create_object(pos: Vector2, object_type: Constants.ObjectType) -> void:
	create_object.emit(pos, object_type)

func emit_scored(points: int) -> void:
	scored.emit(points)
