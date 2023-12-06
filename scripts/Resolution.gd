extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_select_id_pressed(id: int) -> void:
	match id:
		0:
			$CurrentResolution.text = $MenuBar/Select.items[0].text
		1:
			$CurrentResolution.text = $MenuBar/Select.items[1].text
		2:
			$CurrentResolution.text = $MenuBar/Select.items[2].text
		3:
			$CurrentResolution.text = $MenuBar/Select.items[3].text
