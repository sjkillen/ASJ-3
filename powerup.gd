extends Node3D

func _process(delta):
	rotate_y(-delta)

func _on_area_3d_body_entered(body):
	if(body.is_in_group("player")):
		body.get_yumyum()
		queue_free()
