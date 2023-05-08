extends Control

@export var game_scene: PackedScene

@onready var start_button:= $StartButton
@onready var quit_button:= $QuitButton

func _ready() -> void:
	start_button.pressed.connect(self._start_button_pressed)
	quit_button.pressed.connect(self._quit_button_pressed)

func _start_button_pressed():
	get_tree().change_scene_to_file(game_scene.resource_path)

func _quit_button_pressed():
	get_tree().quit()
