extends Node2D

const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://Scenes/Bullets/PlayerBullet/PlayerBullet.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://Scenes/Bullets/EnemyBullet/EnemyBullet.tscn"),
	Constants.ObjectType.EXPLOSION: preload("res://Scenes/Explosion/Explosion.tscn"),
	Constants.ObjectType.PICKUP: preload("res://Scenes/FruitPickup/FruitPickup.tscn"),
}

func _enter_tree() -> void:
	SignalHub.create_bullet.connect(on_create_bullet)
	SignalHub.create_object.connect(on_create_object)

func on_create_bullet(
	pos: Vector2, dir: Vector2, speed: float, object_type: Constants.ObjectType
) -> void:
	if !validate_key:
		return
		
	var new_bullet: BaseBullet = OBJECT_SCENES[object_type].instantiate()
	
	new_bullet.setup(pos, dir, speed)
	
	Callable(add_child).call_deferred(new_bullet)

func on_create_object(pos: Vector2, object_type: Constants.ObjectType) -> void:
	if !validate_key:
		return
		
	var new_object: Node2D = OBJECT_SCENES[object_type].instantiate()
	
	new_object.global_position = pos
	
	Callable(add_child).call_deferred(new_object)

func validate_key(key: Constants.ObjectType) -> bool:
	
	var key_is_valid = OBJECT_SCENES.has(key)
	
	if not key_is_valid:
		print_debug("Key %s doesn't exist in OBJECT_SCENES Dictionary" % Constants.ObjectType.find_key(key))
	
	return key_is_valid
