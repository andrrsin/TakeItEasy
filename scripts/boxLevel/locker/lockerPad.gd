extends Node2D


@onready var label: Label = $Label
@onready var audio_button: AudioStreamPlayer2D = %AudioButton



var current_code : Array[int] = [-1,-1,-1,-1]
var pos : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var aux: int = 0

	for button:Area2D in self.get_node("Buttons").get_children():
		button.input_event.connect(button_pressed.bind(aux))
		aux += 1

# Set the logic and the code
func set_code(number:int):
	
	current_code[pos] = number
	pos+=1
	paint_code()
	
	if pos > 3:	
		pos = 0
		get_node("Lights").submit_code(current_code)
		for i : int in range(current_code.size()):
			current_code[i] = -1
		await get_tree().create_timer(1).timeout
		paint_code()
	
	
func animation_and_sound(_id:int):
	audio_button.play()
# Signal of buttons and set_code by its number
func button_pressed(_viewport:Node,event: InputEvent,_shape_idx:int,id:int) -> void:
	if event is  InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		animation_and_sound(id)
		match id:
			0: set_code(1)
			1: set_code(2)
			2: set_code(3)
			3: set_code(4)
			4: set_code(5)
			5: set_code(6)
			6: set_code(7)
			7: set_code(8)
			8: set_code(9)
			9: set_code(0)

# Frontend layer of code		
func paint_code():
	var text : String = ""
	for num : int in current_code:
		if num == -1:
			text+="*"
		else:
			text+=str(num)
	label.text=text
