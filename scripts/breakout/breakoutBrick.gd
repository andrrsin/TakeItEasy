extends StaticBody2D
signal brick_destroyed
@onready var brick_hit: AudioStreamPlayer2D = $BrickHit

func hit():
	brick_destroyed.emit()
	var sfx := brick_hit
	if sfx:
		# Detach the sound so it can finish after the brick is freed
		sfx.reparent(get_tree().current_scene)
		sfx.global_position = global_position
		sfx.play()
		sfx.finished.connect(func(): sfx.queue_free())
	queue_free()
