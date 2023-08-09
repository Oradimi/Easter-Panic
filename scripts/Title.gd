extends Control

@export var game_scene: PackedScene

@onready var start_button:= $MenuList/StartButton
@onready var settings_button:= $MenuList/SettingsButton
@onready var credits_button:= $MenuList/CreditsButton
@onready var quit_button:= $MenuList/QuitButton

func _ready() -> void:
	start_button.pressed.connect(self._start_button_pressed)
	settings_button.pressed.connect(self._settings_button_pressed)
	credits_button.pressed.connect(self._credits_button_pressed)
	quit_button.pressed.connect(self._quit_button_pressed)

func _start_button_pressed():
	get_tree().change_scene_to_file(game_scene.resource_path)

func _settings_button_pressed():
	pass

func _credits_button_pressed():
	pass

func _quit_button_pressed():
	get_tree().quit()
