extends KinematicBody
class_name KartController

export var ACC:float = .02
export var DEACC:float = .005
export var TURN:float = .2

onready var mesh:Spatial = $Mesh
onready var tire_front = [$Mesh/tire_fl,$Mesh/tire_fr]

var velocity:Vector3
var acceleration:float = 0
var steering:float = 0

var _do_jump:bool = false
var median_velocity:float = 0
var is_grounded:bool = false



var inputs = []
var triggers = []
var trigger_first:int = -1

func _physics_process(delta):
	is_grounded = $RayCast.is_colliding()
	inputs = [
		int(Input.is_action_pressed("cmd_up")),
		int(Input.is_action_pressed("cmd_down")),
		int(Input.is_action_pressed("cmd_left")),
		int(Input.is_action_pressed("cmd_right"))
	]
	
	triggers = [
		int( Input.is_action_pressed("cmd_trigger_left") ),
		int( Input.is_action_pressed("cmd_trigger_right") )
	]
	
	
	
	var vel = (inputs[0] - inputs[1])
	var turn = ( -inputs[3] + inputs[2] )
#	steering = lerp(steering,turn,.002)
	
	
	# smooth acceleration
#	if is_equal_approx(vel,0):
#		acceleration -= DEACC
#	elif is_equal_approx(vel,-1):
#		acceleration += vel * ACC
#	acceleration = clamp(acceleration, 0, 1)

#	if !is_grounded: acceleration = 1
	if is_equal_approx(vel, 0):
		if acceleration > 0:
			acceleration -= DEACC
		elif acceleration < 0:
			acceleration += ACC
	elif is_equal_approx(vel, 1):
		acceleration += ACC
	else: 
		acceleration -= ACC
	acceleration = clamp(acceleration,-1,1)
	
	ScreenDebugger.dict["Acceleration"] = acceleration
	
	# smooth turn
	var desired_vel = -global_transform.basis.z  * 400 * acceleration
	velocity = desired_vel * delta
	
	var hspeed:Vector2 = Vector2(velocity.x,velocity.z)
	median_velocity = floor(abs(hspeed.length()))
	
	#Rotation Stuff
	steering = lerp(steering,turn,TURN)
	rotation_degrees.y += (steering * (median_velocity/6))
	var t = 1
	if !is_equal_approx(turn,0): t = turn
	if acceleration < 0: t = t * -1
	rotate_tires(median_velocity)
	
	ScreenDebugger.dict["turn"] = turn
	ScreenDebugger.dict["T"] = t
	
	#Y stuff
	velocity.y -= 200 * delta
	if _do_jump:
		velocity.y = 10
		_do_jump = false
	
	
	#Look at floor normal
	var normal = $RayCast.get_collision_normal()
	var xform = align_with_y(mesh.global_transform,normal)
	mesh.global_transform = mesh.global_transform.interpolate_with(xform,.2)
#	mesh.rotation_degrees.y = lerp(mesh.rotation_degrees.y,rotation_degrees.y,.2) # make the kart rotate same as the main node
	velocity = move_and_slide(velocity,Vector3.UP,true,4,PI/3)
	
	
	#Debugging
	ScreenDebugger.dict["rotation"] = rotation_degrees.y
	ScreenDebugger.dict["kartRotation"] = mesh.rotation_degrees.y
	ScreenDebugger.dict["grounded"] = is_grounded
	

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func rotate_tires(moving):
	for wheel in tire_front:
		wheel.rotation_degrees.y = steering * 45 * (moving/6)
#		print(str(turn * 45))
	pass
