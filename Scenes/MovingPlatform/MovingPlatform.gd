extends AnimatableBody2D


class TargetDistanceTime:
	
	var _position_to : Vector2
	var _time : float

	func get_position_to() -> Vector2: return _position_to
	func get_time() -> float: return _time
	
	# Constructor
	func _init(position_from: Vector2, position_to: Vector2, speed: float):
		_time = position_from.distance_to(position_to) / speed
		_position_to = position_to

	func _to_string() -> String:
		return "PositionTo: %s, Time: %f" % [_position_to, _time]



@export var targets: Array[Marker2D]
@export var speed: float = 150.0


var _tween: Tween
var _target_points: Array[TargetDistanceTime]

func _ready() -> void:
	if targets.size() < 2:
		queue_free()
	else:
		global_position = targets[0].global_position 
		setup_points()
		set_moving()

func _exit_tree() -> void:
	if _tween:
		_tween.kill()

func setup_points():
	for i in range(len(targets) - 1):
		var np: TargetDistanceTime = TargetDistanceTime.new(
			targets[i].global_position,
			targets[i + 1].global_position,
			speed
		)
		_target_points.append(np)	
	
	var np: TargetDistanceTime = TargetDistanceTime.new(
		targets[targets.size() - 1].global_position,
		targets[0].global_position,
		speed
	)
	_target_points.append(np)

func set_moving() -> void:
	_tween = get_tree().create_tween()
	_tween.set_loops()
	for tp in _target_points:
		_tween.tween_property(self, "global_position",tp.get_position_to(), tp.get_time())
	_tween.tween_interval(0.05)
