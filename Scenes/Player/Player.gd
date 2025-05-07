extends CharacterBody2D

class_name Player

@export var fell_off_y: float = 100.0
@export var lives: int = 5
@export var camera_min: Vector2 = Vector2(-10000, 10000)
@export var camera_max: Vector2 = Vector2(10000, -10000)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var hurt_timer: Timer = $HurtTimer
@onready var shooter: Shooter = $Shooter
@onready var player_cam: Camera2D = $PlayerCam

const JUMP = preload("res://Assets/sound/jump.wav")
const DAMAGE = preload("res://Assets/sound/damage.wav")

const GRAVITY: float = 800.0
const JUMP_SPEED: float = -320.0
const RUN_SPEED: float = 150.0
const JUMP_CUT_MULTIPLIER: float = 0.3
const JUMP_TIMES_LIMIT: int = 2
const MAX_SPEED_FALL: float = 350.0
const JUMP_HURT_VELOCITY: Vector2 = Vector2(0, -130.0)

var _jumps: int = 0
var _is_hurt: bool = false
var _invincible = false
var _bump_up = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var direction: Vector2 = Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT
		shooter.shoot(direction)

func set_camera_limits() -> void:
	player_cam.limit_bottom = camera_min.y
	player_cam.limit_left = camera_min.x
	player_cam.limit_top = camera_max.y
	player_cam.limit_right = camera_max.x

func _ready() -> void:
	set_camera_limits()
	Callable(late_init).call_deferred()

func late_init() -> void:
	SignalHub.emit_player_hit(lives, false)

func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)

func _physics_process(delta: float) -> void:

	apply_gravity(delta)
	handle_input()
	
	velocity.y = clampf(velocity.y, JUMP_SPEED, MAX_SPEED_FALL)

	move_and_slide()
	fallen_off()
	
	if _bump_up:
		velocity.y = velocity.y - 500
		_bump_up = false

func play_effect(effect: AudioStream) -> void:
	sound.stop()
	sound.stream = effect
	sound.play()

func handle_input() -> void:
	if _is_hurt: return
	
	handle_jump_input()
	handle_side_movement()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func handle_jump_input() -> void:
	
	if is_on_floor():
		_jumps = 0
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_SPEED
			play_effect(JUMP)
			_jumps += 1
		elif _jumps < JUMP_TIMES_LIMIT:
			velocity.y = JUMP_SPEED
			play_effect(JUMP)
			_jumps += 1
	

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

func go_invincible() -> void:
	if _invincible: return
	_invincible = true
	
	var tween = create_tween()
	for _i in range(3):
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 0.0), 0.1)
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 1.0), 0.1)
	tween.tween_property(self, "_invincible", false, 0)

func fallen_off() -> void:
	if global_position.y < fell_off_y: return
	
	reduce_lives(lives)

func handle_side_movement() -> void:
	velocity.x = RUN_SPEED * Input.get_axis("left", "right")
	
	if not is_equal_approx(velocity.x, 0):
		sprite_2d.flip_h = velocity.x < 0

func reduce_lives(reduction: int) -> bool:
	lives -= reduction
	SignalHub.emit_player_hit(lives, true)
	if lives <= 0:
		set_physics_process(false)
		return false
	
	return true

func apply_hurt_jump() -> void:
	_is_hurt = true
	velocity = JUMP_HURT_VELOCITY
	hurt_timer.start()
	play_effect(DAMAGE)

func apply_hit() -> void:
	if _invincible: return
	
	if reduce_lives(1) == false:
		return
	
	go_invincible()
	apply_hurt_jump()

func bump_up() -> void:
	_bump_up = true

func _on_hit_box_area_entered(area: Area2D) -> void:
	Callable(apply_hit).call_deferred()

func _on_hurt_timer_timeout() -> void:
	_is_hurt = false
