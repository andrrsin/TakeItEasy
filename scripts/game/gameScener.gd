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
			
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)

	elif !is_gui and current_scene != null:
		if delete:
			current_scene.queue_free()
			
		elif keep_running:
			current_scene.visible = false
		else:
			scenes.remove_child(current_scene)
	var new_scene : Node = null
	if scene_cache.has(path):
		var cached_node = scene_cache[path]
		
		# VITAL FIX: Check if valid AND not currently dying
		if is_instance_valid(cached_node) and not cached_node.is_queued_for_deletion():
			new_scene = cached_node
			# If it is orphaned, add it back
			if new_scene.get_parent() == null:
				if is_gui:
					gui.add_child(new_scene)
				else:
					scenes.add_child(new_scene)
		else:
			# Cache had a dead or dying object. Remove it and reload.
			scene_cache.erase(path)
			new_scene = load(path).instantiate()
			if is_gui:
				gui.add_child(new_scene)
			else:
				scenes.add_child(new_scene)
			scene_cache[path] = new_scene 
			
	else:
		# Not in cache at all, load fresh
		new_scene = load(path).instantiate()
		if is_gui:
			gui.add_child(new_scene)
		else:
			scenes.add_child(new_scene)
		scene_cache[path] = new_scene
		
	# Final Setup
	new_scene.visible = true
	if is_gui:
		current_gui_scene = new_scene
	else:
		current_scene = new_scene
		
func change_gui_scene(new_scene:String, delete:bool = true, keep_running: bool = false) -> void:
	call_deferred("_change_scene", new_scene, delete, keep_running, true)
func change_scene(new_scene:String, delete:bool = true, keep_running: bool = false) -> void:
	call_deferred("_change_scene", new_scene, delete, keep_running, false)
