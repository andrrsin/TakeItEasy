extends Node2D



func check_click(event: InputEvent,scene_name: String) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		Game.game_controller.change_scene("res://scenes/levels/"+scene_name+".tscn",false,true)


func wall_note_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "wallnote")
		

func box_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "box")

func laptop_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "laptop")

func book1_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "books/book1")

func book_click2(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "books/book2")

func book3_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "books/book3")

func book4_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "books/book4")

func book5_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "books/book5")

func book6_click(_viewport:Node,event: InputEvent,_shape_idx:int) -> void:
	check_click(event, "books/book6")


func hint_click(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	check_click(event, "books/hint")
