extends Node

signal beat_passed
signal eighth_beat_passed

@onready var music:= $AudioStreamPlayer

@warning_ignore("unused_private_class_variable")
const _a:= preload("res://scenes/Main.tscn")
const _b:= preload("res://scenes/Title.tscn")
const _c:= preload("res://scenes/GameOver.tscn")

var window: Vector2 = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))

var score: int = 0
var health: int = 3
var difficulty: float = 6.0

# Chattotata
const MUSIC_BPM: float = 103.0 # beats per minute
const MUSIC_SPB: float = 60.0 / MUSIC_BPM # seconds per beat
const MUSIC_START_OFFSET: float = 0.42 # in seconds
const MUSIC_TIME_SIGNATURE: int = 4
var playback_position_beats: float
var beat_cache: Array[float]
var on_beat: bool = false

func _ready() -> void:
	music.play(1.2)

func _process(_delta: float) -> void:
	playback_position_beats = (music.get_playback_position() - MUSIC_START_OFFSET) / MUSIC_SPB
	beat_cache.append(playback_position_beats)
	if beat_cache.size() >= 4:
		if sign(floori(beat_cache[-1] * 1) - floori(beat_cache[-2] * 1)) != 0:
			beat_passed.emit()
		if sign(floori(beat_cache[-1] * 8) - floori(beat_cache[-2] * 8)) != 0:
			eighth_beat_passed.emit()
