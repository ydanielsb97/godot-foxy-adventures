extends CharacterBody2D

class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel

@export var fell_off_y: float = 800.0

const GRAVITY: float = 800.0
const JUMP_SPEED: float = -320.0
const RUN_SPEED: float = 150.0
const JUMP_CUT_MULTIPLIER: float = 0.3
const JUMP_TIMES_LIMIT: int = 2
const MAX_SPEED_FALL: float = 350.0

var jumps: int = 0


const PLAYER_BULLET = preload("res://Scenes/Bullets/PlayerBullet/PlayerBullet.tscn")
@onready var shooter: Shooter = $Shooter

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var direction: Vector2 = Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT
		shooter.shoot(direction)
		#var new_player_bullet = PLAYER_BULLET.instantiate()
		#new_player_bullet.position = global_position
		#get_parent().add_child(new_player_bullet)
		
func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)

func _physics_process(delta: float) -> void:

	apply_gravity(delta)
	
	velocity.y = clampf(velocity.y, JUMP_SPEED, MAX_SPEED_FALL)
	
	handle_jump_input()
	handle_side_movement()
	move_and_slide()
	fallen_off()
	update_debug_label()

func update_debug_label() -> void:
	var debug_string: String = ""
	
	debug_string += "Floor: %s\n" % is_on_floor()
	debug_string += "v:%.1f, %.1f\n" % [velocity.x, velocity.y]
	debug_string += "P:%.1f, %.1f\n" % [global_position.x, global_position.y]
	
	debug_label.text = debug_string

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func handle_jump_input() -> void:
	
	if is_on_floor():
		jumps = 0
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_SPEED
			jumps += 1
		elif jumps < JUMP_TIMES_LIMIT:
			velocity.y = JUMP_SPEED
			jumps += 1
	

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

func fallen_off() -> void:
	if global_position.y > fell_off_y:
		queue_free()

func handle_side_movement() -> void:
	velocity.x = RUN_SPEED * Input.get_axis("left", "right")
	
	if not is_equal_approx(velocity.x, 0):
		sprite_2d.flip_h = velocity.x < 0
	
