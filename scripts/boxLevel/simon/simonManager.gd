extends Node2D

# --Exports--
@export var buttons : Array[SimonButton]
@export var time_in_level: float = 7.0
@export var reward_code_number:int = 6
# ------------

# --References--
@onready var display: Label = $Display
@onready var timer: Timer = $Timer
enum State {START,LEVEL1,LEVEL2,LEVEL3,LEVEL4,GAME_OVER} 
# -----------

#--Button Related--
var acum : int = 0
var selected_buttons : Array[SimonButton]
var is_active_input = true
var tween : Tween
# ---------------------

# --State Machine--
var current_state=State.START
# -----------------

# -- Boot up & Utilities--
func _ready() -> void:
	display.text = ";)"
	connect_buttons()
	start_state()
	
func connect_buttons():
	var aux = 0
	for button : Area2D in buttons:
		button.input_event.connect(func(_vp, event, _idx): _on_button_input(event, aux))
		aux += 1

func start_level_preconditions():
	is_active_input = false
	turn_off_lights()
	acum = 0
	selected_buttons.clear()
	timer.stop()

func light_flash(button:SimonButton,time:float):
		button.audio_stream_player_2d.play()
		if tween: tween.kill()
		tween = create_tween()
		tween.tween_property(button.light, "energy", 14, time)
		tween.tween_property(button.light, "energy", 0.0, time)
		await tween.finished
# -----------------------------------
# ---------- STATE MACHINE -----------
# Starts the game and redirects input
func _on_button_input(event:InputEvent, id: int):
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT) or !is_active_input:
		return

	match current_state:
		State.START:
			print("Game Started!")
			await stop_start_mode()
			acum = 0
			await start_level_1()
			timer.start(time_in_level)
			display.text="?"
		_:
			handle_game_input(selected_buttons,id)
# Handles the inputs of the buttons and decides if next level or game over
func handle_game_input(level_order:Array[SimonButton], id: int):
	# Assert de que haya lista
	assert(!level_order.is_empty(),"NO LEVEL BUTTONS")
	# Miramos que hayamos presionado el botón que es
	
	if level_order[acum] == buttons[id]:
		print("Key",acum, " is correct")
		# Iluminamos 
		await light_flash(level_order[acum],0.1)
		acum+=1
		if level_order.size() <= acum:
			load_next_level()
	else: #Al fallo perdemos
		game_over()

func game_over():
	timer.stop()
	print("--GAME OVER--")
	display.text="X"
	is_active_input=false
	await get_tree().create_timer(1).timeout
	display.text=";)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),-14.1)
	start_state()

func reward_player():
	start_level_preconditions()
	display.text = ":)"
	await get_tree().create_timer(2).timeout
	for button : Area2D in buttons:
		var light : Light2D = button.get_child(1)
		if light: light.energy = 0
	display.text = str(reward_code_number)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),-14.1)
	print("GAME WON")
	
func load_next_level():
	display.text = ":)"
	is_active_input=false
	match current_state:
		State.LEVEL1:
			await start_level_2()
			timer.start(time_in_level)
		State.LEVEL2:
			await start_level_3()
			timer.start(time_in_level)
		State.LEVEL3:
			await start_level_4()
			timer.start(time_in_level)
		State.LEVEL4:
			await reward_player()
		

# --------------START STATE-----------
func start_state():
	current_state = State.START
	is_active_input=true
	if tween: tween.kill()
	tween = create_tween()
	# ~~Loop through the buttons ~~
	tween.set_loops()
	
	for button in buttons:
		var light = button.get_child(1) as Light2D
		if light:
			# No llamamos a light_flash ya que no queremos awaits
			tween.tween_property(light, "energy", 14, 0.3)
			tween.tween_property(light, "energy", 0.0, 0.3)
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
func turn_off_lights():
	is_active_input = false
	if tween:
		tween.kill() # Stops the flashing immediately
		tween = null
	# Checks to turn off
	for button : Area2D in buttons:
		var light : Light2D = button.get_child(1)
		if light: light.energy = 0
func stop_start_mode():
	turn_off_lights()
	# ~~ Count down ~~
	display.text = "3"
	await get_tree().create_timer(1).timeout
	display.text = "2"
	await get_tree().create_timer(1).timeout
	display.text = "1"
	await get_tree().create_timer(1).timeout
	#Bajamos el volumen
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),-25.0)
	tween=create_tween()
	# ~~~~~~~~~~~~~~~~~~
# ----------------------------------------	
# --------- Level 1 (4 buttons 7 seconds) --------
func start_level_1():
	print("--Start Level 1--")
	# Preconditions
	start_level_preconditions()
	display.text = "!"
	await get_tree().create_timer(1).timeout
	display.text = "1"
	
	var button:SimonButton
	
	# select 4 buttons randomly and light them
	for i in range(4):
		button = buttons.pick_random()
		self.selected_buttons.append(button)
		print("Light",i," on")
		await light_flash(button,0.4)
		print("Light",i," off")
		
	is_active_input = true
	current_state = State.LEVEL1
# --------- Level 2 (5 buttons 7 seconds) --------
func start_level_2():
	print("--Start Level 2--")
	# Preconditions
	start_level_preconditions()
	await get_tree().create_timer(1).timeout
	display.text = "2"
	
	var button:SimonButton
	
	# select 5 buttons randomly and light them
	for i in range(5):
		button = buttons.pick_random()
		self.selected_buttons.append(button)
		print("Light",i," on")
		await light_flash(button,0.4)
		print("Light",i," off")
		
	is_active_input = true
	current_state = State.LEVEL2
# --------- Level 2 (6 buttons 7 seconds) --------
func start_level_3():
	print("--Start Level 3--")
	# Preconditions
	start_level_preconditions()
	await get_tree().create_timer(1).timeout
	display.text = "3"
	
	var button:SimonButton
	
	# select 5 buttons randomly and light them
	for i in range(6):
		button = buttons.pick_random()
		self.selected_buttons.append(button)
		print("Light",i," on")
		await light_flash(button,0.4)
		print("Light",i," off")
		
	is_active_input = true
	current_state = State.LEVEL3
# --------- Level 2 (7 buttons 7 seconds) --------
func start_level_4():
	print("--Start Level 4--")
	# Preconditions
	start_level_preconditions()
	await get_tree().create_timer(1).timeout
	display.text = "4"
	
	var button:SimonButton
	
	# select 7 buttons randomly and light them
	for i in range(7):
		button = buttons.pick_random()
		self.selected_buttons.append(button)
		print("Light",i," on")
		await light_flash(button,0.4)
		print("Light",i," off")
		
	is_active_input = true
	current_state = State.LEVEL4
