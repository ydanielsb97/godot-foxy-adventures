extends Node

signal create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
)

signal create_object(pos: Vector2, object_type: Constants.ObjectType)

signal player_hit(lives: int, shake: bool)
signal scored(points: int)
signal boss_killed

func emit_player_hit(lives: int, shake: bool) -> void:
	player_hit.emit(lives, shake)

func emit_boss_killed() -> void:
	boss_killed.emit()

func emit_create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
) -> void:
	create_bullet.emit(pos, dir, speed, object_type)

func emit_create_object(pos: Vector2, object_type: Constants.ObjectType) -> void:
	create_object.emit(pos, object_type)

func emit_scored(points: int) -> void:
	scored.emit(points)
