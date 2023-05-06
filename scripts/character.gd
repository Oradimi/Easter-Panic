extends CharacterBody2D

var window = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), 
	ProjectSettings.get_setting("display/window/size/viewport_height"))
	
@onready var bubble = get_node("Bubble")
@onready var bubble_heart = get_node("Bubble_heart")
@onready var main = get_node("/root/Main_scene")

var target_position: Vector2
var speed: float
var char_anim_wait
var frame_flag = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wish = Sprite2D.new()
	wish.texture = load("res://art/egg.png")
	wish.set_scale(Vector2(0.55, 0.55))
	wish.rotate(- PI / 6)
	bubble.add_child(wish)
	if get_meta("hasHeart"):
		var heart = Sprite2D.new()
		heart.texture = load("res://art/heart.png")
		heart.set_scale(Vector2(0.55, 0.55))
		heart.rotate(PI / 6)
		bubble_heart.add_child(heart)
	else:
		remove_child(bubble_heart)
	color_decide(wish)
	speed = randf_range(80, 200 / main.difficulty);
	target_position = path_decide()
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	var direction = global_position.direction_to(target_position)
	if direction.x < 0: $Sprite2D.scale.x = -1
	velocity = direction * speed
	char_anim_wait = 11600 - int(10000 * global.music.get_playback_position()) % 11600
	$Sprite2D.frame = int(char_anim_wait / 2900)
	char_anim_wait = char_anim_wait % 2900

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_and_slide()
	z_index = int(position.y)

func _process(delta: float) -> void:
	char_anim_wait = char_anim_wait + delta * 10000
	if frame_flag == 5:
		modulate = Color(1, 1, 1, modulate.a * 0.99)
	if char_anim_wait >= 2900:
		if get_meta("hasEgg") and frame_flag != 5:
			match frame_flag:
				0:
					$Bubble.queue_free()
					if $Bubble_heart: $Bubble_heart.queue_free()
					set_meta("type", 4)
					velocity = Vector2.ZERO
					$Sprite2D.frame = 4
					frame_flag += 1
					char_anim_wait = 0
				1:
					$Sprite2D.frame = 5
					frame_flag += 1
					char_anim_wait = 0
				2:
					$Sprite2D.frame = 4
					frame_flag += 1
					char_anim_wait = 0
				3:
					$Sprite2D.frame = 5
					frame_flag += 1
					char_anim_wait = 0
				4:
					velocity = Vector2(randf_range(-100, 100), randf_range(-100, 100)).normalized() * speed * 2
					if velocity.x > 0:
						$Sprite2D.scale.x = 1
					else:
						$Sprite2D.scale.x = -1
					frame_flag += 1
		else:
			$Sprite2D.frame = ($Sprite2D.frame + 1) % $Sprite2D.hframes
			char_anim_wait = 0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if !get_meta("hasEgg"):
		get_tree().call_group("main_scene", "_change_HP", -1, position)
	queue_free()

func path_decide():
	match randi_range(0, 3):
		0:
			global_position = Vector2(randf_range(100, window.x - 100), - 200)
			target_position = Vector2(randf_range(100, window.x - 100), window.y + 100)
		1:
			global_position = Vector2(randf_range(100, window.x - 100), window.y + 100)
			target_position = Vector2(randf_range(100, window.x - 100), - 200)
		2:
			global_position = Vector2(- 100, randf_range(100, window.y - 100))
			target_position = Vector2(window.x + 100, randf_range(100, window.y - 100))
		3:
			global_position = Vector2(window.x + 100, randf_range(100, window.y - 100))
			target_position = Vector2(- 100, randf_range(100, window.y - 100))
	return target_position

func color_decide(wish):
	match get_meta("type"):
		0:
			wish.modulate = Color.RED
		1:
			wish.modulate = Color.BLUE
		2:
			wish.modulate = Color.YELLOW
		3:
			wish.modulate = Color.DARK_GREEN
