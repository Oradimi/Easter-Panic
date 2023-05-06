extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ButtonStart.pressed.connect(self._button_start_pressed)
	#$ButtonStart.modulate = Color(1, 1, 1, 0)
	$ButtonQuit.pressed.connect(self._button_quit_pressed)
	#$ButtonQuit.modulate = Color(1, 1, 1, 0)#
	$Score.text = str(global.score) + " points"
	var rank = get_rank(global.score)
	display_rank(rank)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _button_start_pressed():
	global.score = 0
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _button_quit_pressed():
	get_tree().quit()

func get_rank(score):
	var rank = 0
	if score > 2500:
		rank = 4
	elif score > 1600:
		rank = 3
	elif score > 900:
		rank = 2
	elif score > 400:
		rank = 1
	return rank

func display_rank(rank):
	match rank:
		0:
			$Rank_char.texture = load("res://art/rank/rank_D.png")
			$Rank_letter.texture = load("res://art/rank/rank_letter_D.png")
		1:
			$Rank_char.texture = load("res://art/rank/rank_C.png")
			$Rank_letter.texture = load("res://art/rank/rank_letter_C.png")
		2:
			$Rank_char.texture = load("res://art/rank/rank_B.png")
			$Rank_letter.texture = load("res://art/rank/rank_letter_B.png")
		3:
			$Rank_char.texture = load("res://art/rank/rank_A.png")
			$Rank_letter.texture = load("res://art/rank/rank_letter_A.png")
		4:
			$Rank_char.texture = load("res://art/rank/rank_S.png")
			$Rank_letter.texture = load("res://art/rank/rank_letter_S.png")
