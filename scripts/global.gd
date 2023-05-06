extends Node

var score = 0
@onready var music = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
