extends Node2D

var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), 
	ProjectSettings.get_setting("display/window/size/viewport_height"))
@onready var character = preload("res://scenes/character.tscn")
@onready var egg = preload("res://scenes/egg.tscn")
@onready var tray = get_node("Tray")

const HEART_SIZE = 128

var difficulty = 6.0
var time_character = difficulty * 0.5
var time_egg = difficulty * 0.5
var score = 0
var egg_type_count = [0, 0, 0, 0]
var heart_anim_wait
var game_over

# Random tweaking arrays
var array_egg_2 = [0, 1, 2, 3]
var array_egg_1 = [0, 1, 2, 3, array_egg_2.pop_at(randi_range(0, array_egg_2.size() - 1))]
var array_char_2 = [0, 1, 2, 3]
var array_char_1 = [0, 1, 2, 3, array_char_2.pop_at(randi_range(0, array_char_2.size() - 1))]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over = false
	set_meta("HP", 3)
	$UI/HP/Hearts.size.x = HEART_SIZE * get_meta("HP")
	heart_anim_wait = int(10000 * global.music.get_playback_position()) % 5800
	$UI/HP/Hearts.texture.set_pause(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !game_over:
		if heart_anim_wait > 0:
			heart_anim_wait = clamp(heart_anim_wait - delta, 0.0, 1.0)
		elif heart_anim_wait == 0:
			$UI/HP/Hearts.texture.set_pause(false)
			heart_anim_wait = -1
		time_character += delta
		time_egg += delta
		if time_character > difficulty:
			time_character = 0
			var character_instance = setup_object(character, array_char_1, array_char_2)
			var hasHeart = !randi_range(0, 30)
			character_instance.set_meta("hasHeart", hasHeart)
			add_child(character_instance)
		if time_egg > clamp(difficulty * 0.4, 1, 8.0):
			time_egg = 0
			var egg_instance = setup_object(egg, array_egg_1, array_egg_2)
			tray.add_child(egg_instance)
	else:
		if ($Mask.scale.x > 1.1):
			$Mask.scale = $Mask.scale - Vector2(delta, delta) * 12 * ($Mask.scale / 20)
		else:
			fade.transition_to("res://scenes/game_over.tscn")

func _change_HP(change, char_position):
	set_meta("HP", clamp(get_meta("HP") + change, 0, 6))
	$UI/HP/Hearts.size.x = HEART_SIZE * get_meta("HP")
	if get_meta("HP") == 0 and !game_over:
		$Mask.position = char_position
		game_over = true

func _add_score():
	global.score += 10
	difficulty = clamp(10.0 / sqrt(global.score / 6.0), 1.3, 6.0) 
	$UI/HP/Label.text = str(global.score)

func setup_object(object, array_1, array_2):
	var instance = object.instantiate()
	var type = choose_color(array_1, array_2)
	instance.set_meta("type", type)
	return instance

func choose_color(array_1, array_2):
	if array_2.is_empty():
		array_2.append_array([0, 1, 2, 3])
	if array_1.is_empty():
		array_1.append_array([0, 1, 2, 3, array_2.pop_at(randi_range(0, array_2.size() - 1))])
	return array_1.pop_at(randi_range(0, array_1.size() - 1))

static func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum
