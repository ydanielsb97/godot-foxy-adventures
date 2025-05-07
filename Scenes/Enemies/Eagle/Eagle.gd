extends EnemyBase

@export var fly_speed: Vector2 = Vector2(35, 15)

@onready var shooter: Shooter = $Shooter
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var direction_timer: Timer = $DirectionTimer

var _fly_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	velocity = _fly_direction
	move_and_slide()
	shoot()

func fly_to_player() -> void:
	flip_me()
	_fly_direction = fly_speed
	
	if !animated_sprite_2d.flip_h:
		_fly_direction.x = -_fly_direction.x
	
	direction_timer.start()

func shoot() -> void:
	if player_detector.is_colliding():
		var direction: Vector2 = global_position.direction_to(_player_ref.global_position)
		shooter.shoot(direction)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("fly")
	Callable(fly_to_player).call_deferred()
	direction_timer.start()

func _on_direction_timer_timeout() -> void:
	Callable(fly_to_player).call_deferred()
