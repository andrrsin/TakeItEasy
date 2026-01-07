class_name GameController extends Node

@export var scenes: Node2D 
@export var gui: Control 

var current_scene
var current_gui_scene

func _ready() -> void:
	Game.game_controller = self
	current_gui_scene = $GUI/Prueba
	current_scene = $Scenes/MainScene

func change_gui_scene(new_scene:String, delete:bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new
pass # Replace with function body.
func change_scene(new_scene:String, delete:bool = true, keep_running: bool = false) -> void:
	if current_scene != null:
		if delete:
			current_scene.queue_free() # Removes
		elif keep_running:
			current_scene.visible = false # Keeps it and keeps it running
		else:
			gui.remove_child(current_scene) # Keeps it in memory but not running
	var new = load(new_scene).instantiate()
	add_child(new)
	current_scene = new
