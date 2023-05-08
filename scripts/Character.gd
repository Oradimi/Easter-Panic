extends CharacterBody2D

class_name Character

signal health_changed
signal score_changed

@export var egg_resource: Resource
@export var heart_resource: Resource
@export var heart_chance: int = 30

@onready var sprite:= $Sprite2D
@onready var bubble_wish:= $BubbleWish
@onready var bubble_heart:= $BubbleHeart
@onready var bubble_wish_sprite:= $BubbleWish/Sprite2D
@onready var bubble_heart_sprite:= $BubbleHeart/Sprite2D
@onready var animation_offset: float = randi_range(0, (sprite.hframes * 8 - 1)) / 8.0

var egg_wishes: Array[int]
var has_heart: bool
var target_position: Vector2
var speed: float = randf_range(80, 200 / global.difficulty)
var idle_frames: int = 0
var is_idle: bool = false

func _ready() -> void:
	global.eighth_beat_passed.connect(_on_eighth_beat_passed)

	var wish:= setup_bubble(egg_resource, bubble_wish)
	wish.modulate = egg_color_decide()
	bubble_wish_sprite.add_child(wish)
	if has_heart:
		var heart:= setup_bubble(heart_resource, bubble_heart)
		bubble_heart_sprite.add_child(heart)
	else:
		remove_child(bubble_heart)

	target_position = path_decide()
	var direction:= global_position.direction_to(target_position)
	if direction.x < 0:
		sprite.scale.x = -1
	velocity = direction * speed

func _physics_process(_delta: float) -> void:
	move_and_slide()
	z_index = int(200 + position.y)

	if egg_wishes.is_empty() and idle_frames == 0:
		modulate = Color(1, 1, 1, modulate.a * 0.99)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if !egg_wishes.is_empty():
		health_changed.emit(-1, position)
	queue_free()

func _on_eighth_beat_passed() -> void:
	if idle_frames == 0 and is_idle:
		is_idle = false
		move_in_random_direction()

	var adjusted_animation_time:= absf(global.playback_position_beats - animation_offset)
	sprite.frame = floori((adjusted_animation_time) * 2)\
			% (sprite.hframes - 2 * sign(idle_frames))\
			+ sprite.hframes * sign(idle_frames)

	if is_idle:
		idle_frames -= 1
		velocity = Vector2.ZERO

func _on_egg_dropped(found_index: int) -> void:
	score_changed.emit(+10)
	egg_wishes.pop_at(found_index)
	if egg_wishes.is_empty():
		if has_heart:
			health_changed.emit(+1)
			bubble_heart.queue_free()
		bubble_wish.queue_free()
		is_idle = true
		idle_frames = 14

func move_in_random_direction() -> void:
	velocity = Vector2(randf_range(-100, 100), randf_range(-100, 100)).normalized() * speed * 2
	if velocity.x > 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1

func path_decide() -> Vector2:
	var target: Vector2 = Vector2.ZERO
	match randi_range(0, 3):
		0:
			global_position = Vector2(randf_range(100, global.window.x - 100), - 100)
			target = Vector2(randf_range(100, global.window.x - 100), global.window.y + 100)
		1:
			global_position = Vector2(randf_range(100, global.window.x - 100), global.window.y + 100)
			target = Vector2(randf_range(100, global.window.x - 100), - 100)
		2:
			global_position = Vector2(- 100, randf_range(100, global.window.y - 100))
			target = Vector2(global.window.x + 100, randf_range(100, global.window.y - 100))
		3:
			global_position = Vector2(global.window.x + 100, randf_range(100, global.window.y - 100))
			target = Vector2(- 100, randf_range(100, global.window.y - 100))
	return target

func egg_color_decide() -> Color:
	for egg_color in egg_wishes:
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

func setup_bubble(resource: Resource, bubble: Node2D) -> Sprite2D:
	var object_sprite:= Sprite2D.new()
	object_sprite.texture = load(resource.resource_path)
	object_sprite.set_scale(Vector2(0.55, 0.55))
	object_sprite.position.y -= 20
	object_sprite.rotate(-bubble.rotation)
	return object_sprite
