extends KinematicBody
class_name KartController

var velocity:Vector3
var acc:float = 0
var turning:float = 0
var speed:float
const MAX_SPEED = 18.4#.7
const ACC:float = 4.0#5.0
const DEACC:float = .9
const TURN:float = 1.13
var curve:float = 0
var initial_position
var initial_rot
var initial_mesh_rot
var acceleration = 0
var tire_rot:float = 0
var input_turn = 0
var input_forward = 0

onready var video:VideoPlayer = get_node("../VideoPlayer")
func _ready():
	initial_position = translation
	initial_rot = rotation
	initial_mesh_rot = $mesh.rotation

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

var slow= false
func _process(delta):
	if Input.is_action_just_pressed("cmd_trigger_right"):
		video.play()
	if Input.is_action_just_pressed("ui_accept"):
		slow = !slow
		if slow: Engine.time_scale = .1
		else: Engine.time_scale = 1
	
func _physics_process(delta):
	if Input.is_action_just_pressed("cmd_trigger_left"):
		velocity = Vector3.ZERO
		rotation = initial_rot
		translation = initial_position
		$mesh.rotation = initial_mesh_rot
	velocity.y += delta * -18.5
	
#	velocity = Vector3.ZERO

	input_turn = (-int(Input.is_action_pressed("cmd_right")) + int(Input.is_action_pressed("cmd_left")) )
	input_forward = -int(Input.is_action_pressed("cmd_up")) + int(Input.is_action_pressed("cmd_down"))
	tire_rot = input_turn
	ScreenDebugger.dict["tire_rot"] = tire_rot
	# Using only the horizontal velocity, interpolate towards the input.
	var hvel = velocity
	hvel.y = 0
	
	if is_on_floor():
#		velocity.y = 0
		var normal = $RayCast.get_collision_normal()
		var xform = align_with_y($mesh.global_transform, normal)
		$mesh.global_transform = $mesh.global_transform.interpolate_with(xform,.5)
	
	var target = global_transform.basis.z * input_forward * MAX_SPEED
	var type = 0
	if input_forward < 0:
		type = ACC
	elif input_forward > 0:
		type = DEACC
	acceleration = lerp(acceleration,type,.07)
	ScreenDebugger.dict["Acceleration"] = acceleration
	

	hvel = hvel.linear_interpolate(target, acceleration * delta)

	# Assign hvel's values back to velocity, and then move.
	velocity.x = hvel.x
	velocity.z = hvel.z
	
#	acc = lerp(acc,input_forward,.1)
	
	turning = input_turn * delta * TURN * abs(input_forward)
	rotate_y(turning)
#	speed = -$mesh.global_transform.basis.z * acc * 10
#	ScreenDebugger.dict["Speed"] = speed
#	ScreenDebugger.dict["Acc"] = acc
#	velocity.x = speed.x
#	velocity.z = speed.z

	velocity = move_and_slide(velocity,Vector3.UP,true,4,PI/3)
	speed = Vector2(velocity.x,velocity.z).length()
	ScreenDebugger.dict["Velocity"] = velocity
#	ScreenDebugger.dict["ActualSpeed"] = sqrt(pow(velocity.x,2) + pow(velocity.z,2))
	ScreenDebugger.dict["Turning"] = turning
	ScreenDebugger.dict["Speed"] = speed
	
	
func vector_step(vector:Vector3,step:float):
	return Vector3(stepify(vector.x,step),stepify(vector.y,step),stepify(vector.z,step))
