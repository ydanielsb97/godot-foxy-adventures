extends Node2D

const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://Scenes/Bullets/PlayerBullet/PlayerBullet.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://Scenes/Bullets/EnemyBullet/EnemyBullet.tscn"),
}

func _enter_tree() -> void:
	SignalHub.create_bullet.connect(on_create_bullet)

func on_create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
) -> void:
	if !OBJECT_SCENES.has(object_type):
		print_debug("Key %s doesn't exist in OBJECT_SCENES Dictionary" % Constants.ObjectType.find_key(object_type))
		return
		
	var new_bullet: BaseBullet = OBJECT_SCENES[object_type].instantiate()
	
	new_bullet.setup(pos, dir, speed)
	
	Callable(add_child).call_deferred(new_bullet)
