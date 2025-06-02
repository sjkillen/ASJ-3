extends Node3D
var going = false
func _process(delta):
	if(going):
		rotate(Vector3(0,0,1),delta*0.1)
