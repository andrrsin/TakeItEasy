extends Area2D



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Game.game_controller.change_scene("res://scenes/main_scene.tscn")
		print("going to main")
