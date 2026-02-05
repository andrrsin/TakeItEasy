extends Node2D


@export var red_light: PointLight2D
@export var green_light: PointLight2D
@onready var wrong: AudioStreamPlayer2D = %Wrong
@onready var correct: AudioStreamPlayer2D = %Correct

func _ready():
	if red_light: red_light.energy = 0.0
	if green_light: green_light.energy = 0.0

# Call this function when the player presses the submit button
func submit_code(input_code: Array[int]):
	# Esto une el array de ints y lo convierte en string
	var current_code = "".join(PackedStringArray(input_code))
	if current_code == Game.code:
		Game.sound_controller.play_important(correct)
		flash_light(green_light)
		await get_tree().create_timer(1).timeout
		Game.game_controller.change_scene("res://scenes/end_scene.tscn")	
	else:
		Game.sound_controller.play_important(wrong)
		flash_light(red_light)
		


func flash_light(light: PointLight2D):
	if light == null:
		return
		
	# Create the Tween it is for interpolation
	var tween = create_tween()
	
	
	tween.tween_property(light, "energy", 14, 0.1)
	
	
	tween.tween_interval(0.4)
	
	
	tween.tween_property(light, "energy", 0.0, 0.1)
