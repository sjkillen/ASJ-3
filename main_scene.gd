extends Node3D

func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("debug button"):
		pass

func _on_level_2_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 2
		$"big empty forest/SpotLight3D/Timer".start(2)
func _on_level2_spotlight_timer_timeout():
	$"big empty forest/SpotLight3D".set_color(Color(.9,.9,.9,1))
	$"big empty forest/SpotLight3D2".set_color(Color(.9,.9,.9,1))
	$"big empty forest/SpotLight3D2".set_color(Color(.9,.9,.9,1))
	
	$"big empty forest/SpotLight3D".visible = true
	$"big empty forest/SpotLight3D2".visible = true
	$"big empty forest/SpotLight3D3".visible = true
	
func _on_level_3_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 3
		#$"big empty forest/SpotLight3D".set_color(Color(1,.5,.5,1))
		$"big empty forest/SpotLight3D2".set_color(Color(1,.4,.4,1))
		$"big empty forest/SpotLight3D2".set_color(Color(1,.4,.4,1))
	
func _on_level_4_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 4
	follow_my_roots()
func follow_my_roots():
	$"big empty forest/followmyroots".going = true
	pass

func _on_death_barrier_body_entered(body):
	if(body.is_in_group("player")):
		var target
		match Globals.level:
			1: target = $"level switch/level1".get_global_position()
			2: target = $"level switch/level2".get_global_position()
			3: target = $"level switch/level3".get_global_position()
			4: target = $"level switch/level4".get_global_position()
			5: target = $"level switch/level5".get_global_position()
		body.gravity = 0
		var tween = create_tween()
		tween.tween_property(body,"global_position",target,1.5)
		tween.tween_property(body,"gravity",ProjectSettings.get_setting("physics/3d/default_gravity"),0.1)
		tween.tween_property(body,"hitpoints",3,1)
		pass
