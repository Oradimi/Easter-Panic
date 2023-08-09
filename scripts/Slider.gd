extends HBoxContainer

@onready var slider:= $PanelContainer/HSlider
@onready var bar:= $PanelContainer/TextureProgressBar
@onready var volume_level:= $Level

func _ready() -> void:
	setValue(slider)

func _input(event: InputEvent) -> void:
	if (Input.is_action_pressed("leftClick")):
		setValue(slider)

func setValue(slider: HSlider):
	var percent_volume:= int(slider.value * 100)
	volume_level.text = str(percent_volume)
	bar.value = slider.value
	global.music.volume_db = linear_to_db(slider.value) - 6.0
