extends Node

@onready var character: Node = $"../.."
@onready var armature: Node = $"../../Armature"
@onready var animPlayer: Node = $AnimationPlayer


func _on_combat_controller_right_jab() -> void:
	if animPlayer.is_playing() && animPlayer.current_animation == "left_jab":
		pass
	else:
		animPlayer.play("right_jab")
	pass


func _on_combat_controller_left_jab() -> void:
	if animPlayer.is_playing() && animPlayer.current_animation == "right_jab":
		pass
	else:
		animPlayer.play("left_jab")
	pass
