extends Node3D


@onready var animation: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	animation.travel("Test")
