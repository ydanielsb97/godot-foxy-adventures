extends CharacterBody2D

class_name EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var points: int = 1
@export var speed: float = 30.0

const FALL_OFF_Y: float = 800.0

var _gravity: float = 800.0
var _player_ref: Player

func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if _player_ref == null:
		queue_free()

func _physics_process(delta: float) -> void:
	if global_position.y > FALL_OFF_Y:
		queue_free()

func die() -> void:
	set_physics_process(false)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass


func _on_hit_box_area_entered(area: Area2D) -> void:
	die()
