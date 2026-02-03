extends TextureButton

@onready var back: TextureButton = %Back

func _ready() -> void:
	back.pressed.connect(_go_to_main)

func _go_to_main() -> void:
		Game.game_controller.change_scene("res://scenes/main_scene.tscn")
		
