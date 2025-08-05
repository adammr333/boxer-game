extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		toggle_pause()
	pass


func toggle_pause():
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass
