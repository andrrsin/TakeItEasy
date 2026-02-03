extends Control

@onready var play_button: Button = $VBox/PlayButton
@onready var settings_button: Button = $VBox/SettingsButton
@onready var exit_button: Button = $VBox/ExitButton

@onready var settings_panel: Panel = $SettingsPanel
@onready var master_slider: HSlider = $SettingsPanel/VBox/MasterSlider
@onready var music_slider: HSlider = $SettingsPanel/VBox/MusicSlider
@onready var sfx_slider: HSlider = $SettingsPanel/VBox/SfxSlider
@onready var close_settings_button: Button = $SettingsPanel/VBox/CloseButton

func _ready() -> void:
	settings_panel.visible = false
	
	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	close_settings_button.pressed.connect(_on_close_settings)
	
	master_slider.value_changed.connect(func(value: float): _set_volume(value, "Master"))
	music_slider.value_changed.connect(func(value: float): _set_volume(value, "Music"))
	sfx_slider.value_changed.connect(func(value: float): _set_volume(value, "SFX"))
	
	_sync_volume_sliders()
	_setup_custom_cursor()

func _on_play_pressed() -> void:
	# Start the game
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_settings_pressed() -> void:
	settings_panel.visible = true
	_sync_volume_sliders()

func _on_close_settings() -> void:
	settings_panel.visible = false

func _on_exit_pressed() -> void:
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
