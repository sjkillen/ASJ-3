extends MeshInstance3D
func _physics_process(delta):
	rotate(Vector3(1,2.9,3.141592).normalized(),delta)
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.add_cube()
		queue_free()
