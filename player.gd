extends CharacterBody3D
class_name Player

var gravity = 9.8
var speed = 4.5
var runspeed = 20
var currentspeed = speed
var jump_speed = 4.9  # determines jump height
var mouse_sensitivity = 0.002  # turning speed
var hitpoints = 3
var runpoints = 16
var running = false
signal death
var yumyum = false
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_z(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(90), deg_to_rad(90))
		
	if event.is_action_pressed("exit game"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	if Input.is_action_just_pressed("toggle light"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			if($Camera3D/flashlight/SpotLight3D.visible): $Camera3D/flashlight/SpotLight3D.visible = false
			else: $Camera3D/flashlight/SpotLight3D.visible = true
#	if Input.is_action_just_pressed("interact"):
#		pass
		
func get_input():
	var input = Input.get_vector("move_back","move_forward","strafe_left", "strafe_right")
	return input

func _physics_process(delta):
	if(not yumyum):
		if(Input.is_action_just_pressed("run")):
			if(runpoints > 0):
				running = true
				currentspeed = runspeed
		else: if(Input.is_action_just_released("run")):
			running = false
			currentspeed = speed
		if running and is_moving_2d():
			runpoints -= delta*3
			if(runpoints < 0): 
				currentspeed=speed
				running = false
		else:
			currentspeed = speed
			runpoints += delta*4.2
			if(runpoints > 16): runpoints = 16
	$ProgressBar2.value = runpoints
	velocity.y += -gravity * delta
	var input = get_input()
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * currentspeed
	velocity.z = movement_dir.z * currentspeed
	move_and_slide()
	if (yumyum):
		if(Input.is_action_just_pressed("run")):
			yum()
func get_yumyum():
	$"YumYum Grains".visible = true
	yumyum = true
func yum():
	var tween = create_tween()
	var tween2 = create_tween()
	tween2.tween_property($"Camera3D/flashlight","rotation",Vector3(0,0,0),0.15)
	tween.tween_property($"YumYum Grains","position",Vector3(1.015,-0.02,0.89),0.09)
	tween2.tween_property($"Camera3D/flashlight","position",Vector3(-0.5,-.538,-.787),0.36)
	tween.tween_property($"YumYum Grains","rotation",Vector3(0,deg_to_rad(107.7),deg_to_rad(-14)),0.05)
	tween.tween_property($"YumYum Grains","rotation",Vector3(0,deg_to_rad(107.7),deg_to_rad(14)),0.1)
	tween.tween_property($"YumYum Grains","rotation",Vector3(0,deg_to_rad(107.7),deg_to_rad(-14)),0.1)
	tween.tween_property($"YumYum Grains","rotation",Vector3(0,deg_to_rad(107.7),0),0.08)
	tween.tween_property($"YumYum Grains","position",Vector3(1.015,0,0.89),0.09)
	tween2.tween_property($"Camera3D/flashlight","rotation",Vector3(0,deg_to_rad(90),0),0.1)
	var findpigs = get_tree().get_nodes_in_group("pig")
	for pig in findpigs:
		pig.moving_toward_player = true
		pig.find_child("AggroTimer").start(1.25)

func is_moving_2d() -> bool:
	return Vector2(velocity.x, velocity.z).length() > 0.01

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
