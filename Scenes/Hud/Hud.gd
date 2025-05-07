extends Control

const GAME_OVER = preload("res://Assets/sound/game_over.ogg")
const YOU_WIN = preload("res://Assets/sound/you_win.ogg")

@onready var score_label: Label = $MarginContainer/VBoxContainer2/HBoxContainer/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MarginContainer/VBoxContainer2/HBoxContainer/HBHearts
@onready var color_rect: ColorRect = $ColorRect
@onready var v_box_game_over: VBoxContainer = $ColorRect/VBoxGameOver
@onready var v_box_complete: VBoxContainer = $ColorRect/VBoxComplete
@onready var vb_keyboard_controls: VBoxContainer = $MarginContainer/VBoxContainer2/VBKeyboardControls
@onready var vb_xbox_controller: VBoxContainer = $MarginContainer/VBoxContainer2/VBXboxController
@onready var timer: Timer = $Timer
@onready var sound: AudioStreamPlayer = $Sound

var _score: int = 0

var _hearts: Array
var _can_continue: bool = true

func _ready() -> void:
	_hearts = hb_hearts.get_children()
	_score = GameManager.cached_score
	update_score_label()
	Input.connect("joy_connection_changed", _on_joy_connection_changed)
	if Input.get_connected_joypads().size() > 0:
		show_controls_guide(true)

func _on_joy_connection_changed(device_id: int, connected: bool):
	show_controls_guide(connected)

func show_controls_guide(is_gamepad: bool) -> void:
	vb_keyboard_controls.visible = !is_gamepad
	vb_xbox_controller.visible = is_gamepad

func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("exit") and _can_continue:
		GameManager.load_main()

	if event.is_action_pressed("shoot") and _can_continue and v_box_game_over.visible:
		GameManager.load_main()
		
	if event.is_action_pressed("shoot") and _can_continue and v_box_complete.visible:
		#TODO: GameManager.load_next_level() When next level is created
		GameManager.load_main()

func _enter_tree() -> void:
	SignalHub.scored.connect(on_scored)
	SignalHub.player_hit.connect(on_player_hit)
	SignalHub.level_complete.connect(on_level_complete)

func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)

func on_scored(points: int) -> void:
	_score += points
	update_score_label()
	
func on_player_hit(lives: int, shake: bool) -> void:
	for index in range(_hearts.size() - lives):
		_hearts[index].modulate = "#000000"
	
	if lives <= 0:
		on_level_complete(false)


func on_level_complete(complete: bool) -> void:
	color_rect.show()
	_can_continue = false
	
	if complete:
		v_box_complete.show()
		sound.stream = YOU_WIN
	else:
		v_box_game_over.show()
		sound.stream = GAME_OVER
	timer.start()
	sound.play()
	get_tree().paused = true

func update_score_label() -> void:
	score_label.text = "%05d" % _score

func _on_timer_timeout() -> void:
	_can_continue = true
