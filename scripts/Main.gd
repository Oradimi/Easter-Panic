extends Node2D

@export var max_health: int = 6
@export var game_over_scene: PackedScene
@export var character_scene: PackedScene
@export var egg_scene: PackedScene

@onready var tray:= $Tray
@onready var score_label:= $UI/HP/ScoreLabel
@onready var hearts:= $UI/HP/Hearts
@onready var mask:= $Mask

const HEART_SIZE: int = 128

var character_time: float
var egg_time: float
var character_time_threshold: float
var egg_time_threshold: float
var game_over: bool = false

# Arrays containing the next colors
var array_egg_2: Array[int]
var array_egg_1: Array[int]
var array_char_2: Array[int]
var array_char_1: Array[int]

func _ready() -> void:
	global.beat_passed.connect(_on_beat_passed)
	global.score = 0
	global.health = 3
	global.difficulty = 6.0
	character_time = global.difficulty * 0.5
	egg_time = global.difficulty * 0.5
	character_time_threshold = global.difficulty
	egg_time_threshold = clamp(global.difficulty * 0.4, 1.0, 8.0)
	hearts.size.x = HEART_SIZE * global.health
	score_label.text = str(global.score)

func _physics_process(delta: float) -> void:
	if !game_over:
		process_game(delta)
	else:
		process_game_over(delta)

func _on_health_changed(value: int, char_position: Vector2 = Vector2.ZERO) -> void:
	global.health = clamp(global.health + value, 0, max_health)
	hearts.size.x = HEART_SIZE * global.health
	if global.health == 0 and !game_over:
		game_over = true
		mask.position = char_position

func _on_score_changed(value: int) -> void:
	global.score += value
	score_label.text = str(global.score)
	global.difficulty = clamp(10.0 / sqrt(global.score / 6.0), 1.3, 6.0)
	character_time_threshold = global.difficulty
	egg_time_threshold = clamp(global.difficulty * 0.4, 1.0, 8.0)

func _on_beat_passed() -> void:
	if floori(global.playback_position_beats) % 2:
		hearts.texture.set_frame_texture(0, hearts.texture.get_frame_texture(2))
	else:
		hearts.texture.set_frame_texture(0, hearts.texture.get_frame_texture(1))

func process_game(delta: float) -> void:
	character_time += delta
	egg_time += delta
	if character_time > character_time_threshold:
		character_time = 0
		var character:= setup_character(character_scene, array_char_1, array_char_2)
		add_child(character)
	if egg_time > egg_time_threshold:
		egg_time = 0
		var egg:= setup_egg(egg_scene, array_egg_1, array_egg_2)
		tray.add_child(egg)

func process_game_over(delta: float) -> void:
	if (mask.scale.x > 1.1):
		mask.scale = mask.scale - Vector2(delta, delta) * 12 * (mask.scale / 20)
	else:
		fade.transition_to(game_over_scene)

func setup_character(object: Object, array_1: Array[int], array_2: Array[int]) -> Character:
	var instance:= object.instantiate() as Character
	var color: int = choose_color(array_1, array_2)
	instance.has_heart = !randi_range(0, instance.heart_chance)
	instance.egg_wishes.append(color)
	instance.health_changed.connect(_on_health_changed)
	instance.score_changed.connect(_on_score_changed)
	return instance

func setup_egg(object: Object, array_1: Array[int], array_2: Array[int]) -> Egg:
	var instance:= object.instantiate() as Egg
	var color: int = choose_color(array_1, array_2)
	instance.egg_color = color
	return instance

func choose_color(array_1: Array[int], array_2: Array[int]) -> int:
	if array_2.is_empty():
		array_2.append_array([0, 1, 2, 3])
	if array_1.is_empty():
		array_1.append_array([0, 1, 2, 3, array_2.pop_at(randi_range(0, array_2.size() - 1))])
	return array_1.pop_at(randi_range(0, array_1.size() - 1))
