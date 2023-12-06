extends Node

@export var scenes: Dictionary = {
	Title = "res://scenes/Title.tscn",
	Main = "res://scenes/Main.tscn",
	GameOver = "res://scenes/GameOver.tscn",
}

# Description: Add a new scene to the scene collection
# Parameter sceneAlias: The alias used for finding the scene in the collection
# Parameter scenePath: The full path to the scene file in the file system
func add_scene(scene_alias: String, scene_path: String) -> void:
	scenes[scene_alias] = scene_path

# Description: Remove an existing scene from the scene collection
# Parameter sceneAlias: The scene alias of the scene to remove from the collection
func remove_scene(scene_alias: String) -> void:
	scenes.erase(scene_alias)

# Description: Switch to the requested scene based on its alias
# Parameter sceneAlias: The scene alias of the scene to switch to
func switch_scene(scene_alias: String) -> void:
	get_tree().change_scene_to_file(scenes[scene_alias])

# Description: Restart the current scene
func restart_scene() -> void:
	get_tree().reload_current_scene()

# Description: Quit the game
func quit_game() -> void:
	get_tree().quit()

#const Main:= preload("res://scenes/Main.tscn")
#const Title:= preload("res://scenes/Title.tscn")
#const GameOver:= preload("res://scenes/GameOver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main_scene: StringName = ProjectSettings.get_setting("application/run/main_scene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
