extends CharacterBody2D


@export var SPEED = 17.0
@export var JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var direction:Vector2 = Input.get_vector("move left", "move right","move up","move down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		if direction.x > 0:
			animated_sprite_2d.flip_h=true
		elif direction.x < 0:
			animated_sprite_2d.flip_h=false
		animated_sprite_2d.play("run")
	else:
		velocity = Vector2.ZERO
		animated_sprite_2d.play("idle")
	# aplicar la velocity
	move_and_slide()
	
