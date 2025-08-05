extends Node

@onready var character: Node = $"../.."
@onready var cameraPivot: Node3D = $"../../SpringArmPivot"

var canJab: bool

signal attack
signal right_jab
signal left_jab


func _ready() -> void:
	canJab = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && canJab:
		print("RIGHT JAB!")
		emit_signal("right_jab")
		emit_signal("attack")
	if event.is_action_pressed("right_click") && canJab:
		print("LEFT JAB!")
		emit_signal("left_jab")
		emit_signal("attack")
	pass


func _on_movement_controller_sprint() -> void:
	canJab = false
	pass


func _on_movement_controller_stop_sprint() -> void:
	canJab = true
	pass
