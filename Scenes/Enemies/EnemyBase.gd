extends CharacterBody2D

class_name EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var points: int = 1
@export var speed: float = 30.0

const FALL_OFF_Y: float = 800.0

var _gravity: float = 800.0
var _player_ref: Player

func _ready() -> void:
	_player_ref = GameManager.get_player_ref()

func _physics_process(delta: float) -> void:
	if global_position.y > FALL_OFF_Y:
		queue_free()

func die() -> void:
	set_physics_process(false)
	SignalHub.emit_create_object(global_position, Constants.ObjectType.PICKUP)
	SignalHub.emit_create_object(global_position, Constants.ObjectType.EXPLOSION)
	SignalHub.emit_scored(points)
	queue_free()
	
func flip_me() -> void:
	animated_sprite_2d.flip_h = _player_ref.global_position.x > global_position.x
	
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass


func _on_hit_box_area_entered(area: Area2D) -> void:
	die()
