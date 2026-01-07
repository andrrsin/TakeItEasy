extends Node2D


@export var red_light: PointLight2D
@export var green_light: PointLight2D


func _ready():
	if red_light: red_light.energy = 0.0
	if green_light: green_light.energy = 0.0

# Call this function when the player presses the submit button
func submit_code(input_code: Array[int]):
	# Esto une el array de ints y lo convierte en string
	var current_code = "".join(PackedStringArray(input_code))
	if current_code == Game.code:
		flash_light(green_light)
	else:
		flash_light(red_light)


func flash_light(light: PointLight2D):
	if light == null:
		return
		
	# Create the Tween it is for interpolation
	var tween = create_tween()
	
	# fade in 0.1 seconds
	tween.tween_property(light, "energy", 14, 0.1)
	
	# Hold the light for 0.2 seconds
	tween.tween_interval(0.3)
	
	# Fade out in 0.5 seconds
	tween.tween_property(light, "energy", 0.0, 0.1)
