extends CanvasLayer

# Reference to the _AnimationPlayer_ node
@onready var _anim_player = $AnimationPlayer
var is_transitionning = false

func _ready() -> void:
	# Plays the animation backward to fade in
	_anim_player.play_backwards("fade")

func transition_to(scene) -> void:
	if is_transitionning:
		return
	is_transitionning = true
	print_stack()
	# Plays the Fade animation and wait until it finishes
	_anim_player.play("fade")
	
	await _anim_player.animation_finished

	# Changes the scene
	get_tree().change_scene_to_file(scene)
	await get_tree().process_frame
	_anim_player.play_backwards("fade")
	is_transitionning = false
