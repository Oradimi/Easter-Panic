extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ButtonStart.pressed.connect(self._button_start_pressed)
	#$ButtonStart.modulate = Color(1, 1, 1, 0)
	$ButtonQuit.pressed.connect(self._button_quit_pressed)
	#$ButtonQuit.modulate = Color(1, 1, 1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _button_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _button_quit_pressed():
	get_tree().quit()
