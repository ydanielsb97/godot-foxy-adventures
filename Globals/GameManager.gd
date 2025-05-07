
extends Node


const MAIN = preload("res://Scenes/Main/Main.tscn")
const LEVEL_BASE = preload("res://Scenes/LevelBase/LevelBase.tscn")

const Levels: Array[PackedScene] = [
	preload("res://Scenes/LevelBase/Level1/Level1.tscn"),
	preload("res://Scenes/LevelBase/Level2/Level2.tscn")
]

const SCORES_PATH = "user://high_scores.tres"


var high_scores: HighScores = HighScores.new()
var _current_level: int = -1

# score to carry over between levels
var cached_score: int:
	set (value):
		cached_score = value
	get:
		return cached_score


func _input(event: InputEvent) -> void:
	pass
	#if Input.is_key_pressed(KEY_Q):
		#get_tree().quit()


func _ready() -> void:
	load_high_scores()

func _exit_tree():
	save_high_scores()


func load_main():
	cached_score = 0
	_current_level = -1
	get_tree().change_scene_to_packed(MAIN)


func load_next_level():
	_current_level += 1
	if _current_level >= Levels.size():
		_current_level = 0
	get_tree().change_scene_to_packed(Levels[_current_level])


func load_high_scores():		
	if ResourceLoader.exists(SCORES_PATH):
		high_scores = load(SCORES_PATH)
		pass


func save_high_scores():
	ResourceSaver.save(high_scores, SCORES_PATH)


# try this each time game is over / level complete
func try_add_new_score(score: int):
	high_scores.add_new_score(score)
	save_high_scores()	
	cached_score = score

func get_player_ref() -> Player:
	return get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
