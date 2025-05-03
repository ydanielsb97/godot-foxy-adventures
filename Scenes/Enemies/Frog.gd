extends EnemyBase

@onready var jump_timer: Timer = $JumpTimer

const JUMP_VELOCITY_R: Vector2 = Vector2(100, -150)
const JUMP_VELOCITY_L: Vector2 = Vector2(-100, -150)

var _seen_player: bool = false
var _can_jump: bool = false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	velocity.y += _gravity * delta
	if is_on_floor():
		velocity = Vector2.ZERO
		animated_sprite_2d.play("idle")
	
	apply_jump()
	move_and_slide()
	
	if _seen_player:
		flip_me()

func flip_me() -> void:
	animated_sprite_2d.flip_h = _player_ref.global_position.x > global_position.x

func apply_jump() -> void:
	if !is_on_floor() or !_can_jump:
		return
	
	if !_seen_player:
		return
	
	velocity = JUMP_VELOCITY_R if animated_sprite_2d.flip_h else JUMP_VELOCITY_L
	
	_can_jump = false
	start_timer()
	animated_sprite_2d.play("jump")

func start_timer() -> void:
	jump_timer.start(randf_range(2, 3))

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !_seen_player:
		_seen_player = true
		start_timer()

func _on_jump_timer_timeout() -> void:
	_can_jump = true
