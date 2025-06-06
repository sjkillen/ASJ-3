extends NavigationAgent3D

var starting_region: RID
var nav_ready := false
var wander_location: Vector3
var wander_location_valid := false
var safe_velocity: Vector3
var safe_velocity_valid := false

# Method is async because it takes a few frames for the nav region to register
func save_current_region():
	var map: RID = get_parent().get_world_3d().get_navigation_map()
	while true:
		for region in NavigationServer3D.map_get_regions(map):
			if NavigationServer3D.region_owns_point(region, get_parent().global_position):
				starting_region = region
				nav_ready = true
				return
		map = await NavigationServer3D.map_changed

func path_to_random():
	if not nav_ready:
		return
	wander_location = NavigationServer3D.region_get_random_point(starting_region, 1, false)
	wander_location_valid = true

func _process(_delta: float) -> void:
	if get_parent().moving_toward_player:
		target_position = get_parent().target_to_pursue.global_position
	elif wander_location_valid:
		target_position = wander_location

func get_path_pos() -> Vector3:
	if not get_parent().moving_toward_player and not wander_location_valid:
		return get_parent().global_position
	return %NavigationAgent3D.get_next_path_position()

func wander():
	if not wander_location_valid or is_target_reached() or not is_target_reachable():
		path_to_random()


func _on_navigation_finished() -> void:
	if not get_parent().moving_toward_player:
		path_to_random()

func velocity_computed(s: Vector3):
	safe_velocity = s
	safe_velocity_valid = true

func safen_velocity(v: Vector3) -> Vector3:
	if not safe_velocity_valid:
		return v
	return safe_velocity
