extends Button

@onready var settings_menu:= owner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(self._close_settings_button_pressed)

func _close_settings_button_pressed() -> void:
	settings_menu.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
