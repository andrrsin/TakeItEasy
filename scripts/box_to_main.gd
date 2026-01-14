extends Area2D




func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		Game.game_controller.change_scene("res://scenes/main_scene.tscn",false,true)
