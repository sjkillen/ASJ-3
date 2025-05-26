extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0  # movement speed
var jump_speed = 6.0  # determines jump height
var turnspeed = 1.45
var damage = 1

func _physics_process(delta):
	velocity.y += -gravity * delta
	var moving_forward = Vector3(1,0,0)
	rotate_y(turnspeed*delta)
	var movement_dir = transform.basis * Vector3(moving_forward.x, 0, moving_forward.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	move_and_slide()


func _on_damage_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(self)
