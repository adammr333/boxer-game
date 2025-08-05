extends Node

@onready var gameUI: Node = $"../../SpringArmPivot/SpringArm3D/Camera3D/GameUI"
@onready var gameUISquares: Node = $"../../SpringArmPivot/SpringArm3D/Camera3D/GameUI/DirectionSquares"
@onready var swordReadyTimer: Node = $SwordReadyTimer

var swordReady: bool


func _ready() -> void:
	swordReady = false
	gameUISquares.visible = false
	pass


func _process(_delta: float) -> void:
	if swordReady:
		gameUISquares.visible = true
	else:
		gameUISquares.visible = false
	var swordInput: Vector2 = Input.get_vector("r_stick_up", "r_stick_down", "r_stick_right", "r_stick_left")
	var swordAngle: float = swordInput.angle()
	print(swordAngle)
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") or event.is_action_pressed("left_trigger"):
		swordReady = true
		swordReadyTimer.stop()
		print("Sword is Ready")
	if event.is_action_released("left_click") or event.is_action_released("left_trigger"):
		swordReadyTimer.start()
		#swordReady = false
		print("Sword is Not Ready")
	if event is InputEventMouseMotion:
		if event.relative.x < 0:
			print("left")
		if event.relative.x > 0:
			print("right")
		if event.relative.y < 0:
			print("up")
		if event.relative.y > 0:
			print("down")
		print(event.relative)
	pass


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#swordReady = true
		#print("Sword is Ready")
	#if event.is_action_released("left_click"):
		#swordReady = false
		#print("Sword is Not Ready")
	#if event is InputEventMouseMotion:
		#if event.relative.x < 0:
			#print("left")
		#if event.relative.x > 0:
			#print("right")
		#if event.relative.y < 0:
			#print("up")
		#if event.relative.y > 0:
			#print("down")
		#print(event.relative)
	#pass


func _on_sword_ready_timer_timeout() -> void:
	swordReady = false
	pass
