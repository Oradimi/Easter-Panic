extends Control

@export var game_scene: PackedScene
@export var rank_conditions: Array[int]
@export var rank_char_resources: Array[Resource]
@export var rank_letter_resources: Array[Resource]

@onready var start_button:= $StartButton
@onready var quit_button:= $QuitButton
@onready var score_label:= $ScoreLabel
@onready var rank_char:= $RankChar
@onready var rank_letter:= $RankLetter

func _ready() -> void:
	start_button.pressed.connect(self._start_button_pressed)
	quit_button.pressed.connect(self._quit_button_pressed)
	score_label.text = str(global.score) + " points"
	var rank:= get_rank(global.score)
	display_rank(rank)

func _start_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene.resource_path)

func _quit_button_pressed() -> void:
	get_tree().quit()

func get_rank(score: int) -> int:
	for rank in range(rank_conditions.size() - 1, -1, -1):
		if score >= rank_conditions[rank]:
			return rank
	return -1

func display_rank(rank: int) -> void:
	if rank == -1:
		return
	rank_char.texture = rank_char_resources[rank]
	rank_letter.texture = rank_letter_resources[rank]
