extends CharacterBody3D

#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 9.8
var speed = 9.5
var turnspeed = 1.45
var damage = 1
var target_to_pursue
var moving_forward = Vector3(1,0,0)
func _ready():
	target_to_pursue = get_tree().get_nodes_in_group("player")[0]
func _physics_process(delta):
	velocity.y += -gravity * delta
	if(not(Globals.level == 2 or Globals.level == 5)): 
		rotate_y(turnspeed*delta)
	else: 
		look_at(Vector3(
		target_to_pursue.get_global_position().x,get_global_position().y,target_to_pursue.get_global_position().z
		),Vector3.UP)
		rotate_y(deg_to_rad(90))
		
	var movement_dir = transform.basis * Vector3(moving_forward.x, 0, moving_forward.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	move_and_slide()


func _on_damage_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(self)
