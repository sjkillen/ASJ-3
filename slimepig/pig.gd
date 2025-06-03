extends Node3D

@onready var animation: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

func walk() -> void:
	animation.travel("Walking")
	
func idle() -> void:
	animation.travel("Idle")
