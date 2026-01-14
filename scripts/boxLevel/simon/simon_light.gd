extends Area2D
class_name SimonButton
@export var gradient_resource : Texture2D
@export var gradient: Gradient
@export var audio: AudioStreamMP3
@onready var light: PointLight2D = $Light
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	light.texture = gradient_resource
	light.texture.gradient = gradient
	audio_stream_player_2d.stream = audio
