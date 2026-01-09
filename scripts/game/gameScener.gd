class_name GameController extends Node

@export var scenes: Node2D 
@export var gui: Control 

# small cache para saber que escenas estan cargadas
var scene_cache: Dictionary = {}

var current_scene
var current_gui_scene

func _ready() -> void:
	Game.game_controller = self
	current_gui_scene = $GUI/Prueba
	current_scene = $Scenes/MainScene
	scene_cache.set("res://scenes/main_scene.tscn",current_scene)
	

func _change_scene(path:String, delete:bool = true, keep_running: bool = false, is_gui=false) -> void:
	# Unload
	if is_gui and current_gui_scene != null:
		if delete:
			current_gui_scene.queue_free()
			scene_cache.erase(path)
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)

	elif !is_gui and current_scene != null:
		if delete:
			current_scene.queue_free()
			scene_cache.erase(path)
		elif keep_running:
			current_scene.visible = false
		else:
			scenes.remove_child(current_scene)
	# Load
	var new_scene : Node = null	
	# Si esta cargado lo cogemos
	if scene_cache.has(path):
		new_scene = scene_cache[path]
		# Si esta orfanado lo añadimos
		if new_scene.get_parent() == null:
			#Añadimos a subnodo correspondiente
			if is_gui: gui.add_child(new_scene)
			else: scenes.add_child(new_scene)
		new_scene.visible = true
		if is_gui: current_gui_scene = new_scene
		else: current_scene = new_scene
	else:
		new_scene = load(path).instantiate()
		if is_gui: gui.add_child(new_scene)
		else: scenes.add_child(new_scene)
		current_scene=new_scene
		scene_cache.set(path,new_scene)
		
		
func change_gui_scene(new_scene:String, delete:bool = true, keep_running: bool = false) -> void:
	_change_scene(new_scene,delete,keep_running,true)
func change_scene(new_scene:String, delete:bool = true, keep_running: bool = false) -> void:
	_change_scene(new_scene,delete,keep_running)
