extends CharacterBody2D

var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), 
	ProjectSettings.get_setting("display/window/size/viewport_height"))

@onready var main = get_node("/root/Main_scene")

var target_position: Vector2
var speed: float
var selected = false
var collision = false

var is_mouse_over = false
var is_held = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_decide()
	speed = 140;
	global_position = Vector2(- 100, window.y - 100)
	target_position = Vector2(window.x + 100, window.y - 100)
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	var direction = global_position.direction_to(target_position)
	velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !selected:
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _on_area_2d_mouse_entered() -> void:
	is_mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	is_mouse_over = false

func _unhandled_input(event: InputEvent) -> void:
	if is_mouse_over:
		if event.is_action_pressed("leftClick"):
			handle_click_pressed(event)
		elif event.is_action_released("leftClick") and selected:
			handle_click_released()

func color_decide():
	match get_meta("type"):
		0:
			modulate = Color.RED
		1:
			modulate = Color.BLUE
		2:
			modulate = Color.YELLOW
		3:
			modulate = Color.DARK_GREEN

func handle_click_pressed(event):
	is_held = event.is_pressed()
	get_viewport().set_input_as_handled()
	selected = true

func handle_click_released():
	is_held = false
	selected = false
	var flag = [0, 0, 0, 0, 0]
	var area = $Area2D.get_overlapping_areas()
	if area:
		var object
		for i in range(0, area.size()):
			object = area[i].get_parent()
			if object.is_in_group("character") and object.get_meta("type") == get_meta("type"):
				flag[0] = 1
				if object.get_meta("hasHeart"):
					flag[4] = 1
				break
			elif object.is_in_group("tray"):
				flag[1] = 1
			elif object.is_in_group("character"):
				flag[2] = 1
			elif object.is_in_group("egg"):
				flag[3] = 1
		match flag:
			[1, var _x, var _y, var _z, var hasHeart]:
				get_tree().call_group("main_scene", "_add_score")
				if hasHeart:
					get_tree().call_group("main_scene", "_change_HP", 1, Vector2.ZERO)
				queue_free()
				object.set_meta("hasEgg", true)
			[0, 0, 1, 0, 0], [0, 0, 0, 1, 0]:
				queue_free()
	else:
		queue_free()

