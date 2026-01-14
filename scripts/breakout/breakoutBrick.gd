extends StaticBody2D
signal brick_destroyed
func hit():
	brick_destroyed.emit()

	queue_free()
