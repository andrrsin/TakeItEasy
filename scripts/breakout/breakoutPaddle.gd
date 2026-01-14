extends CharacterBody2D


const SPEED = 500.0
const PADDLE_Y_POS = 178.0


func _physics_process(_delta: float) -> void:

	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	global_position.y = PADDLE_Y_POS
