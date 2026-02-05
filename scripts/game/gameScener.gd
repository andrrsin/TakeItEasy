class_name GameController extends Node

@export var scenes: Node2D 
@export var gui: Control 

@onready var settings_button: TextureButton = $SoundManager/GUI/SettingsButton
@onready var settings_panel: Panel = $SoundManager/GUI/SettingsPanel
@onready var master_slider: HSlider = $SoundManager/GUI/SettingsPanel/VBox/MasterSlider
@onready var music_slider: HSlider = $SoundManager/GUI/SettingsPanel/VBox/MusicSlider
@onready var sfx_slider: HSlider = $SoundManager/GUI/SettingsPanel/VBox/SfxSlider
@onready var close_button: Button = $SoundManager/GUI/SettingsPanel/VBox/ButtonRow/CloseButton
@onready var exit_button: Button = $SoundManager/GUI/SettingsPanel/VBox/ButtonRow/ExitButton

# small cache para saber que escenas estan cargadas
var scene_cache: Dictionary = {}

var current_scene
var current_gui_scene

func _ready() -> void:
	Game.game_controller = self
	
	current_scene = $SoundManager/Scenes/MainScene
	scene_cache.set("res://scenes/main_scene.tscn",current_scene)
	settings_panel.visible = false
	settings_button.pressed.connect(_toggle_settings)
	close_button.pressed.connect(_close_settings)
	exit_button.pressed.connect(_exit_game)
	master_slider.value_changed.connect(func(value: float): _set_volume(value, "Master"))
	music_slider.value_changed.connect(func(value: float): _set_volume(value, "Music"))
	sfx_slider.value_changed.connect(func(value: float): _set_volume(value, "SFX"))
	_sync_volume_sliders()
	_setup_custom_cursor()
	

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

func _toggle_settings() -> void:
	settings_panel.visible = !settings_panel.visible
	if settings_panel.visible:
		_sync_volume_sliders()

func _close_settings() -> void:
	settings_panel.visible = false

func _exit_game() -> void:
	get_tree().quit()

func _set_volume(value: float, bus: String) -> void:
	if Game.sound_controller:
		Game.sound_controller.set_volume(value, bus)

func _sync_volume_sliders() -> void:
	if Game.sound_controller:
		master_slider.value = Game.sound_controller.master_volume_db
		music_slider.value = Game.sound_controller.music_volume_db
		sfx_slider.value = Game.sound_controller.sfx_volume_db

func _setup_custom_cursor() -> void:
	var cursor_texture = load("res://assets/Cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, Vector2(0, 0))
	
