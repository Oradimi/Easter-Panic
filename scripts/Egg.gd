extends CharacterBody2D

class_name Egg

signal egg_dropped

@onready var area:= $Area2D

var egg_color: int
var target_position: Vector2
var speed: float = 140

var is_mouse_over: bool = false
var is_held: bool = false
var click_released: bool = false

func _ready() -> void:
	modulate = egg_color_decide()
	get_viewport().mouse_exited.connect(_on_mouse_exited)
	global_position = Vector2(- 100, global.window.y - 100)
	target_position = Vector2(global.window.x + 100, global.window.y - 100)
	var direction:= global_position.direction_to(target_position)
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if !is_held:
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _on_area_2d_mouse_entered() -> void:
	is_mouse_over = true

func _on_area_2d_mouse_exited() -> void:
	is_mouse_over = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if !is_held:
		queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if is_mouse_over:
		if event.is_action_pressed("leftClick"):
			is_held = event.is_pressed()
			click_released = is_held
			handle_click_pressed()
		if is_held:
			is_held = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		elif click_released:
			handle_click_released()

func _on_mouse_exited() -> void:
	if is_held:
		handle_click_released()

func egg_color_decide() -> Color:
	match egg_color:
		0:
			return Color.RED
		1:
			return Color.BLUE
		2:
			return Color.YELLOW
		3:
			return Color.DARK_GREEN
	return Color.WHITE

func handle_click_pressed() -> void:
	get_viewport().set_input_as_handled()

func handle_click_released() -> void:
	click_released = false
	var collisions: Array[Area2D] = area.get_overlapping_areas()
	if collisions.is_empty():
		queue_free()
		return
	var character_collisions = collisions.filter(
			func(collision): return collision.owner is Character)
	var on_tray: bool = collisions.size() != character_collisions.size()
	for character_collision in character_collisions:
		var character: Character = character_collision.owner # for intellisense
		var found_index: int = character.egg_wishes.find(egg_color)
		if found_index == -1 and !on_tray:
			queue_free()
		elif found_index != -1:
			egg_dropped.connect(character._on_egg_dropped)
			egg_dropped.emit(found_index)
			queue_free()
			break
