extends CharacterBody3D

var gravity := 9.8
var speed := 2.
var turnspeed := 1.45
var damage := 1.
@onready var target_to_pursue: Player = get_tree().get_nodes_in_group("player")[0]
@export var moving_toward_player := false
const FORWARD := Vector3(1., 0., 0.)
@export var wandering := false

func _ready() -> void:
	await %NavigationAgent3D.save_current_region()
	
func _physics_process(delta):
	velocity.y -= gravity * delta
	if not %NavigationAgent3D.nav_ready:
		return
	
	var next_pos: Vector3 = %NavigationAgent3D.get_path_pos()
	turn_towards(next_pos, delta)
	
	var movement_dir := next_pos - global_position
	movement_dir.y = 0.0
	movement_dir = movement_dir.normalized()
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	move_and_slide()

func _process(_delta: float) -> void:
	if is_moving():
		%pig.walk()
	else:
		%pig.idle()
	if wandering:
		%NavigationAgent3D.wander()


func is_moving() -> bool:
	return Vector2(velocity.x, velocity.z).length() > 0.01

# Turn gradually towards target rather than immediately
func turn_towards(pos: Vector3, delta: float):
	var look_target := Vector3(
		pos.x,
		global_position.y,
		pos.z,
	)
	if global_transform.origin.is_equal_approx(look_target):
		return
	var turned := global_transform.looking_at(look_target, Vector3.UP)
	var turned_basis := turned.basis.rotated(Vector3.UP, deg_to_rad(90)).orthonormalized()
	global_transform.basis = global_transform.basis.orthonormalized().slerp(turned_basis, delta * turnspeed)

func _on_damage_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(self)

func _on_aggro_timer_timeout():
	moving_toward_player = false
	turnspeed *= (randi_range(0, 1)*2)-1 # -1 or 1
