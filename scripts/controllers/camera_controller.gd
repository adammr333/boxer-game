extends Node

@onready var character: Node = $"../.."
@onready var cameraPivot: Node3D = $"../../SpringArmPivot"
@onready var cameraSpring: Node3D = $"../../SpringArmPivot/SpringArm3D"
@onready var camera: Node3D = $"../../SpringArmPivot/SpringArm3D/Camera3D"

@export_group("Camera")
@export_range(0.0, 1.0) var mouseSensitivity: float = 0.15
@export_range(1.0, 10.0) var stickSensitivity: float = 5.0

var cameraInputDirection: Vector2 = Vector2.ZERO #direction that the camera moves when the mouse is moved


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass


func _process(delta: float) -> void:
	var cameraInput: Vector2 = Input.get_vector("r_stick_up", "r_stick_down", "r_stick_right", "r_stick_left")
	if cameraInput: #if the right stick is moved
		cameraSpring.rotation.x -= cameraInput.x * stickSensitivity * delta #moves the camera up and down with the stick
		cameraSpring.rotation.x = clamp(cameraSpring.rotation.x, -PI / 3.0, PI / 3.0) #restricts the vertical movement of the camera
		cameraPivot.rotation.y += cameraInput.y * stickSensitivity * delta #moves the camera left and right with the stick
	cameraSpring.rotation.x -= cameraInputDirection.y * delta #moves the camera up and down with the mouse
	cameraSpring.rotation.x = clamp(cameraSpring.rotation.x, -PI / 3.0, PI / 3.0) #restricts the vertical movement of the camera
	cameraPivot.rotation.y -= cameraInputDirection.x * delta #moves the camera left and right with the mouse
	cameraInputDirection = Vector2.ZERO #resets the cameraInputDirection value back to zero
	pass


#func _input(event: InputEvent) -> void:
	#var cameraMotion: bool = (
	#event is InputEventMouseMotion and
	#Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	#)
	#if cameraMotion:
		#cameraInputDirection = event.screen_relative * mouseSensitivity
	#pass


func _unhandled_input(event: InputEvent) -> void:
	var cameraMotion: bool = (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if cameraMotion:
		cameraInputDirection = event.screen_relative * mouseSensitivity
	pass
