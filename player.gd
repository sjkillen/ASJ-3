extends CharacterBody3D

var gravity = 9.8
var speed = 4.0  # movement speed
var jump_speed = 4.9  # determines jump height
var mouse_sensitivity = 0.002  # turning speed
var hitpoints = 3
var runpoints = 5
var running = false
signal death
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_z(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))
		
	if event.is_action_pressed("exit game"):
		get_tree().quit()
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	if Input.is_action_just_pressed("toggle light"):
		if($Camera3D/flashlight/SpotLight3D.visible): $Camera3D/flashlight/SpotLight3D.visible = false
		else: $Camera3D/flashlight/SpotLight3D.visible = true
#	if Input.is_action_just_pressed("interact"):
#		pass
		
func get_input():
	var input = Input.get_vector("move_back","move_forward","strafe_left", "strafe_right")
	return input

func _physics_process(delta):
	if(Input.is_action_just_pressed("run")):
		if(runpoints > 0):
			running = true
			speed = 20
	else: if(Input.is_action_just_released("run")):
		running = false
		speed=4
	if(running):
		runpoints -= delta*4
		if(runpoints < 0): 
			speed=4
			running = false
	else:
		speed = 4
		runpoints += delta*2
		if(runpoints > 5): runpoints = 5
	$ProgressBar2.value = runpoints
	velocity.y += -gravity * delta
	var input = get_input()
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	move_and_slide()



func add_cube():
	jump_speed = 20
func take_damage(enemy):
	hitpoints = hitpoints - enemy.damage
	position += (get_global_position() - enemy.get_global_position())*0.5
	print("took ",enemy.damage," damage. ",hitpoints," life left")
	var hpprogresstween = self.create_tween()
	hpprogresstween.tween_property($ProgressBar,"value",hitpoints,0.2)
	if(hitpoints==0):
		emit_signal("death",self)
