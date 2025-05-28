extends Node3D

func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("debug button"):
		$"big empty forest/SpotLight3D".visible = true
		$"big empty forest/SpotLight3D2".visible = true
		$"big empty forest/SpotLight3D3".visible = true
	pass

func _on_level_2_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 2
func _on_level_3_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 3
