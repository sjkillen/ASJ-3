extends Node3D

func _process(delta):
	$TextEdit.text = "you are on level " + str(Globals.level)
	pass
	
func _input(event):
	if event.is_action_pressed("debug button"):
		Globals.level += 1


func _on_level_2_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 2
func _on_level_3_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 3
