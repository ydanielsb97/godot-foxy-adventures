extends Node2D


const BG_FILES: Dictionary = {
	1: [
		preload("res://Assets/backgrounds/game_background_1/layers/sky.png"),
		preload("res://Assets/backgrounds/game_background_1/layers/clouds_1.png"),
		preload("res://Assets/backgrounds/game_background_1/layers/clouds_2.png"),
		preload("res://Assets/backgrounds/game_background_1/layers/clouds_3.png"),
		preload("res://Assets/backgrounds/game_background_1/layers/clouds_4.png"),
		preload("res://Assets/backgrounds/game_background_1/layers/rocks_1.png"),
		preload("res://Assets/backgrounds/game_background_1/layers/rocks_2.png")
	],
	2: [
		preload("res://Assets/backgrounds/game_background_2/layers/sky.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/birds.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/clouds_1.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/clouds_2.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/clouds_3.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/pines.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/rocks_1.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/rocks_2.png"),
		preload("res://Assets/backgrounds/game_background_2/layers/rocks_3.png")
	],
	3: [
		preload("res://Assets/backgrounds/game_background_3/layers/sky.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/clouds_1.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/clouds_2.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/ground_1.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/ground_2.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/ground_3.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/plant.png"),
		preload("res://Assets/backgrounds/game_background_3/layers/rocks.png")
	],
	4: [
		preload("res://Assets/backgrounds/game_background_4/layers/sky.png"),
		preload("res://Assets/backgrounds/game_background_4/layers/clouds_1.png"),
		preload("res://Assets/backgrounds/game_background_4/layers/clouds_2.png"),
		preload("res://Assets/backgrounds/game_background_4/layers/ground.png"),
		preload("res://Assets/backgrounds/game_background_4/layers/rocks.png")
	]
}

@export_range(1, 4) var level_number: int = 1
@export var y_offset: float = -1080
@export var layer_scale: float = 1.0



# Called when the node enters the scene tree for the first time.
func _ready():
	add_backgrounds()


func get_increment() -> float:
	return 1.0 / BG_FILES[level_number].size()


func get_sprite(t: Texture2D) -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = t
	sprite.centered = false
	return sprite
	

func add_layer(t: Texture2D, time_offset: float) -> void:
	var sprite = get_sprite(t)
	
	var par_la = Parallax2D.new()
	par_la.scroll_offset.y = y_offset * layer_scale
	par_la.repeat_times = 1
	par_la.repeat_size.x = t.get_width()
	par_la.scroll_scale.x = time_offset
	par_la.scroll_scale.y = 1.0
	par_la.scale = Vector2(layer_scale, layer_scale)
	par_la.add_child(sprite)
	
	add_child(par_la)


func add_backgrounds() -> void:
	var inc = get_increment()
	var time_offset = inc
	var files_list = BG_FILES[level_number]
	
	for index in range(files_list.size()):
		var bg_file: Texture2D = files_list[index]
		if index == 0:
			add_layer(bg_file, 0)
		else:
			add_layer(bg_file, time_offset)
			time_offset += inc
