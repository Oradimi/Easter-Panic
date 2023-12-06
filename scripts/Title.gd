extends Control

@export var game_scene: StringName

@onready var start_button:= $MenuList/StartButton
@onready var settings_button:= $MenuList/SettingsButton
@onready var credits_button:= $MenuList/CreditsButton
@onready var quit_button:= $MenuList/QuitButton

@onready var settings_menu:= $Settings

func _ready() -> void:
	start_button.pressed.connect(self._start_button_pressed)
	settings_button.pressed.connect(self._settings_button_pressed)
	credits_button.pressed.connect(self._credits_button_pressed)
	quit_button.pressed.connect(self._quit_button_pressed)

func _start_button_pressed():
	scene_manager.switch_scene(game_scene)

func _settings_button_pressed():
	settings_menu.set_visible(true)
	settings_menu.set_process_mode(Node.PROCESS_MODE_INHERIT)

func _credits_button_pressed():
	pass

func _quit_button_pressed():
	scene_manager.quit_game()
