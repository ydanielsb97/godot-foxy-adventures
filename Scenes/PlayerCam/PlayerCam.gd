extends Camera2D

@export var shake_strenght: float = 5.0
@export var shake_time: float = 0.3

var _controllers: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	_controllers = get_controllers()

func _enter_tree() -> void:
	SignalHub.player_hit.connect(on_player_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset = Vector2(
		randf_range(-shake_strenght, shake_strenght),
		randf_range(-shake_strenght, shake_strenght)
	)

func reset_camera() -> void:
	set_process(false)
	offset = Vector2.ZERO

func on_player_hit(lives: int, shake: bool) -> void:
	if shake:
		set_process(true)
		for device_id in _controllers:
			shake_controller(device_id)
			
		await get_tree().create_timer(shake_time).timeout
		reset_camera()

func get_controllers() -> Array[int]:
	return Input.get_connected_joypads()

func shake_controller(device_id: int) -> void:
	var weak_magnitude: float = 0.5
	var strong_magnitude: float = 1.0
	var duration: float = 0.5

	Input.start_joy_vibration(0, 0.5, 0.5, 0)

func reset_controller(device_id: int) -> void:
	Input.stop_joy_vibration(device_id)
