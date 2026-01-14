extends CharacterBody2D

@onready var spacebar_to_start: Label = %SpacebarToStart


@export var speed = 200.0
const MAX_SPEED = 350.0  
var direction = Vector2.ZERO
var is_active = false
var can_launch = true
func reset_ball():
	is_active = false
	speed = 200.0 
	

func _ready():
	# Start moving
	is_active = false

func launch_ball():
	is_active = true
	
	var random_x = randf_range(-0.5, 0.5)
	direction = Vector2(random_x, -1.0).normalized()
	speed = 200.0
	
func _physics_process(delta):
	if not is_active:
		
		var paddle = get_parent().get_node_or_null("Paddle")
		if paddle:
			
			global_position.x = paddle.global_position.x
			global_position.y = paddle.global_position.y - 25

		
		if Input.is_action_just_pressed("spacebar") and can_launch:
			spacebar_to_start.visible=false
			launch_ball()
			

		return
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		direction = direction.bounce(collision.get_normal())
		
		var collider = collision.get_collider()
		if collider.has_method("hit"):
			collider.hit()
			
			speed = min(speed + 10.0, MAX_SPEED)
