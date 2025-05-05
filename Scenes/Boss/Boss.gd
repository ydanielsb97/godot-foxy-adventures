extends Node2D

@export var lives: int = 2
@export var points: int = 5

@onready var visuals: Node2D = $Visuals
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hitbox: Area2D = $Visuals/Hitbox
@onready var shooter: Shooter = $Visuals/Shooter
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

var _player_ref: Player
var _invincible: bool = false

func _ready() -> void:
	_player_ref = GameManager.get_player_ref()

func activate_collisions() -> void:
	
	hitbox.set_deferred("monitorable", true)
	hitbox.set_deferred("monitoring", true)

func _on_trigger_area_entered(area: Area2D) -> void:
	animation_tree["parameters/conditions/on_trigger"] = true

func shoot() -> void:
	shooter.shoot(shooter.global_position.direction_to(_player_ref.global_position))

func _on_hitbox_area_entered(area: Area2D) -> void:
	take_damage()

func tween_hit() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(visuals, "position", Vector2.ZERO, 1.8)

func set_invincible(on: bool) -> void:
	_invincible = on

func reduce_lives() -> void:
	lives -= 1
	if lives <= 0:
		SignalHub.emit_scored(points)
		SignalHub.emit_boss_killed()
		queue_free()

func take_damage() -> void:
	if _invincible: return
	
	set_invincible(true)
	state_machine.travel("Hit")
	tween_hit()
	reduce_lives()
