extends Node3D
func _process(_delta):
	pass
func _ready():
	$"let the player explore".start(3)
	#give the player 3 seconds to explore the room at the beginning of the game
	pass

func _on_let_the_player_explore_timeout():
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property($Cylinder,"position",Vector3(1.893,-.4,-.1),4)
	tween2.tween_property($Cube_004,"position",$Cube_004.position,6)
	
	tween.tween_property($Cylinder2,"position",Vector3(5.988,0.102,1.5),4)
	tween2.tween_property($Cube_004,"position",Vector3(6.248,0.991,10.32),2)
