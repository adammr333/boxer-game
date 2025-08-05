extends Node

@onready var character: Node = $"../.."
@onready var armature: Node = $"../../Armature"
@onready var playerBody: Node = $"../../Armature/PlayerBody"
@onready var cameraController: Node = $"../CameraController"
@onready var attackStateTimer: Node = $AttackStateTimer

@export_group("Movement")
@export var moveSpeed: float = 5.0
@export var acceleration: float = 15.0
@export var rotationSpeed: float = 15.0
@export var jumpImpulse: float = 10.0 #jump strength

var defaultMoveSpeed: float
var defaultAcceleration: float
var lastMovementDirection: Vector3 = Vector3.FORWARD #used to make sure that character does not turn when the movement keys are released
var gravity: float = 30.0
var attackState: bool
var canSprint: bool
var sprinting: bool

signal sprint
signal stop_sprint


func _ready() -> void:
	defaultMoveSpeed = moveSpeed
	defaultAcceleration = acceleration
	attackState = false
	canSprint = true
	pass


func _physics_process(delta: float) -> void:
	var verticalVelocity: float = character.velocity.y
	character.velocity.y = 0.0
	character.velocity.y = verticalVelocity - gravity * delta
	var jump: bool = Input.is_action_just_pressed("space") and character.is_on_floor()
	if jump:
		character.velocity.y += jumpImpulse
	var moveInput: Vector2 = Input.get_vector("left", "right", "up", "down")
	var moveDirection = (character.transform.basis * Vector3(moveInput.x, 0, moveInput.y)).normalized()
	moveDirection = moveDirection.rotated(Vector3.UP, cameraController.cameraPivot.rotation.y)
	character.velocity = character.velocity.move_toward(moveDirection * moveSpeed, acceleration * delta)
	if moveDirection.length() > 0.1: #when the character is moving
		lastMovementDirection = moveDirection #stores the movement direction
	var targetAngle: float = Vector3.FORWARD.signed_angle_to(lastMovementDirection, Vector3.UP)
	#^assigns the angle that the characters needs to turn toward (the target angle, the axis that the character rotates on)
	if !attackState:
		armature.global_rotation.y = lerp_angle(armature.global_rotation.y, targetAngle, rotationSpeed * delta)
		#^moves the characters rotation angle from the current angle toward the targetAngle at the rate of rotationSpeed multiplied by delta
	character.move_and_slide()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_shift") && canSprint:
		sprinting = true
		moveSpeed = moveSpeed * 2
		acceleration = acceleration * 5
		attackStateTimer.stop()
		attackState = false
		playerBody.rotation_degrees.x = -20
		playerBody.position.z = -0.15
		emit_signal("sprint")
	if event.is_action_released("left_shift") && sprinting:
		moveSpeed = defaultMoveSpeed
		acceleration = defaultAcceleration
		playerBody.rotation.x = 0
		playerBody.position.z = 0
		emit_signal("stop_sprint")
	pass


func _on_combat_controller_attack() -> void:
	attackState = true
	attackStateTimer.start()
	pass


func _on_attack_state_timer_timeout() -> void:
	attackState = false
	pass


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "right_jab" or anim_name == "left_jab":
		canSprint = false
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "right_jab" or anim_name == "left_jab":
		canSprint = true
	pass
