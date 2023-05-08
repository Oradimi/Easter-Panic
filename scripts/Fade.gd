extends CanvasLayer

@onready var anim_player:= $AnimationPlayer
var is_transitioning: bool = false

func _ready() -> void:
	# Fade in on the title screen
	anim_player.play_backwards("fade")

func transition_to(scene: PackedScene) -> void:
	if is_transitioning:
		return
	is_transitioning = true

	# Fade to black to other scene
	anim_player.play("fade")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(scene.resource_path)

	# Required after a scene change to avoid problems
	await get_tree().process_frame

	# Fade in to other scene
	anim_player.play_backwards("fade")
	is_transitioning = false