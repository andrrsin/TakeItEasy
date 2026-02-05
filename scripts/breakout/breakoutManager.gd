extends Node2D

var lives = 3
var total_bricks = 0

var start_pos_paddle = Vector2(-2, 178) 
var start_pos_ball = Vector2(-2, 155)

@onready var ball = $Ball
@onready var paddle = $Paddle
@onready var lives_label =$Lives
@onready var code = $Code
@onready var spacebar_to_start: Label = %SpacebarToStart

func _ready() -> void:
	spacebar_to_start.visible=true
	var bricks = get_tree().get_nodes_in_group("Bricks")
	total_bricks = bricks.size()
	for brick in bricks:
		brick.brick_destroyed.connect(_on_brick_destroyed)

func _on_brick_destroyed():
	total_bricks -= 1
	
	if total_bricks <= 0:
		game_won()
		
func game_won():
	print("You Win!")

	ball.is_active = false
	ball.velocity = Vector2.ZERO
	ball.can_launch = false
	code.text = "The code is: 7"
		
func _on_game_over_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		lose_life()
		
func game_over():
	
	ball.is_active = false
	ball.velocity = Vector2.ZERO
	print("Game Over!")
	ball.can_launch = false
	lives_label.text = "You Lose!"
	await get_tree().create_timer(2).timeout
	Game.game_controller.change_scene("res://scenes/levels/laptop.tscn")
	
func reset_positions():
	paddle.position = start_pos_paddle
	ball.position = start_pos_ball
	ball.reset_ball()
	spacebar_to_start.visible=true
	
func lose_life():
	lives -= 1
	lives_label.text = "Lives: "+str(lives)
	
	if lives > 0:
		reset_positions()
		
	else:
		game_over()
