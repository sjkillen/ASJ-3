extends Node3D

func _process(_delta):
	pass
	
func _input(event):
	if event.is_action_pressed("debug button"):
		pass
		#end_the_game()

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
		$pig_enemy2.moving_toward_player = false
	
func _on_level_4_body_entered(body):
	if(body.is_in_group("player")):
		Globals.level = 4
		follow_my_roots()
func follow_my_roots():
	$"big empty forest/followmyroots".visible = true
	$"big empty forest/followmyroots".going = true
	var tween = create_tween()
	#var tween2 = create_tween()
	tween.tween_property($"big empty forest/followmyroots roots","position",Vector3(24,0,97),6)
	#tween2.tween_property()
	
	pass

func _on_level_5_body_entered(body):
	if(body.is_in_group("player")):
		$"big empty forest/followmyroots".visible = false
		var tween = create_tween()
		var tween2 = create_tween()
		tween.tween_property($house/Cube_005,"position",$house/Cube_005.position+Vector3(0,0,1),1)
		tween2.tween_property($house/Cube_009,"position",$house/Cube_009.position-Vector3(0,0,1),1)
		$"level switch/level5/Timer".start(1.5)
func _on_level5_timeout():
	Globals.level = 5
	$"big empty forest/followmyroots roots/level6".visible = true
		
func _on_level_6_body_entered(body):
	if(body.is_in_group("pig")):
		#play() pig die
		var mouthclose = $"big empty forest/followmyroots roots/level6/tree mouth/CSGCombiner3D/CSGBox3D"
		var tween = create_tween()
		tween.tween_property(mouthclose,"size",Vector3(4.61,.5,1.715),.18)
		tween.tween_property(mouthclose,"size",Vector3(4.61,1.8,1.715),.18)
		$"big empty forest/followmyroots roots/level6/thirsty".mesh.text = "yum..."
		body.queue_free()
		end_the_game()
		
var game_ending = false
func end_the_game():
	if(not game_ending):
		game_ending = true
		var tween = create_tween()
		var tween2 = create_tween()
		tween.tween_property($"big empty forest/followmyroots roots/MeshInstance3D".get_active_material(0),
		"albedo_color",Color(.9,.14,.02,1),3)
		
		$"big empty forest/Cylinder".get_active_material(0).albedo_color = Color(1,.16,.07,1)
		$"big empty forest/Sphere".get_active_material(0).albedo_color = Color(1,.9,.07,1)
		tween.tween_property(get_tree().get_nodes_in_group("player")[0].get_node("ProgressBar"),"modulate",Color(1,1,1,0),1.5)
		tween.tween_property($"end cutscene","modulate",Color(1,1,1,1),1.5)
		tween.tween_property($"end cutscene","scale",Vector2(12,12),2)
		tween2.tween_property($"end cutscene","position",$"end cutscene".position,6)
		tween2.tween_property($"end cutscene","position",Vector2(-4000,-3100),2)
	


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
		tween.tween_property(body,"gravity",9.8,0.1)
		tween.tween_property(body,"hitpoints",3,.1)
		tween.tween_property(body.get_node("ProgressBar"),"value",3,0.3)


func _on_level_2_pig_start_attack_body_entered(body):
	if(body.is_in_group("player")):
		$pig_enemy2.moving_toward_player = true
