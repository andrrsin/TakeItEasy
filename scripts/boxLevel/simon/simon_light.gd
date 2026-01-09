extends Area2D

@export var gradient_resource : Texture2D
@export var gradient: Gradient
@onready var light: PointLight2D = $Light

func _ready() -> void:
	light.texture = gradient_resource
	light.texture.gradient = gradient
