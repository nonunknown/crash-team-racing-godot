extends KinematicBody
class_name KartController

const ACC:float = 4.0
const DEACC:float = .6
const TURN:float = 1.13
const MAX_KART_SPEED:float = 410.0
const BRAKE_SPEED:float = 6.6

var velocity:Vector3
var acc:float = 0
var turning:float = 0
var speed:float
var curve:float = 0
var initial_position
var initial_rot
var initial_mesh_rot
var acceleration = 0
var tire_rot:float = 0
var input_turn = 0
var input_forward = 0
var last_speed

var skill_data = SpeedData.get_skill(SpeedData.SKILL.ADVANCED)
onready var base_speed:float = skill_data._min
onready var particles:KartParticles = $mesh/center/kart/Particles
onready var animation:KartAnimation = $mesh
#sliding stuff
var jumping:bool = false
var sliding:bool = false
var gas:float = 0
var turbo:int = 0
var sliding_side:int = 0
var reserves:int = 0
var do_turbo:bool = false

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
var _delta
func _process(delta):
	_delta = delta
	ScreenDebugger.dict["BaseSpeed"] = base_speed
	ScreenDebugger.dict["Gas"] = gas
	if Input.is_action_just_pressed("cmd_trigger_right"):
		video.play()
		
	if Input.is_action_just_pressed("ui_accept"):
		slow = !slow
		if slow: Engine.time_scale = .2
		else: Engine.time_scale = 1

func action_jump():
	if Input.is_action_just_pressed("cmd_trigger_left") and is_on_floor():
		velocity.y = 5

func calculate_reserves():
	if reserves == 0: 
		return
	if reserves - _delta <= 0: 
		reserves = 0
		return
	reserves -= _delta

func _physics_process(delta):
	
	calculate_reserves()
	ScreenDebugger.dict["Reserves"] = reserves
	
	if Input.is_action_just_pressed("cmd_reset"):
		velocity = Vector3.ZERO
		rotation = initial_rot
		translation = initial_position
		$mesh.rotation = initial_mesh_rot
	velocity.y +=delta * -25#18.5
#	velocity += global_transform.basis.x
	
	if not is_on_floor():
		jumping = true
#	elif is_on_floor() and Input.is_action_pressed("cmd_trigger_left") and jumping:
#		sliding = true
	else:
		jumping = false
#		sliding = false
	
	
	ScreenDebugger.dict["Slide turn"] = sliding_side
	ScreenDebugger.dict["jumping"] = jumping
#	ScreenDebugger.dict["sliding"] = sliding

	input_turn = (-int(Input.is_action_pressed("cmd_right")) + int(Input.is_action_pressed("cmd_left")) )
	if is_on_floor(): # input forward and back does not influence on air
		input_forward = -int(Input.is_action_pressed("cmd_up")) + int(Input.is_action_pressed("cmd_down"))
	
	
	#turn only if pressing forward (need to adjust)
	turning = input_turn * delta * TURN * abs(input_forward)
	rotate_y(turning)

	# Using only the horizontal velocity, interpolate towards the input.
	var hvel = velocity
	hvel.y = 0
	
	var normal = $RayCast.get_collision_normal()
#	ScreenDebugger.dict["normal"] = normal
	if is_on_floor(): # only align the kart if is on ground
		var xform = align_with_y($mesh.global_transform, normal)
		$mesh.global_transform = $mesh.global_transform.interpolate_with(xform,.1)
#		velocity.y = velocity.y + 1

	#tire rotation variable used by KartAnimation
	tire_rot = input_turn
	ScreenDebugger.dict["tire_rot"] = tire_rot
	
	#target speed
#	global_transform = xform
	
	var slopeDir = Vector3.UP.cross(Vector3.UP.cross(normal))
	var slope = global_transform.basis.z.dot(slopeDir)
	ScreenDebugger.dict["slope"] = slope
	var target = global_transform.basis.z * input_forward * ( base_speed + ( slope * -10) )
	
	ScreenDebugger.dict["target"] = target
	#Acelleration or Deaceleration
	var impulse_type = DEACC
	if input_forward < 0:
		impulse_type = ACC
	elif input_forward > 0:
		impulse_type = DEACC
	acceleration = impulse_type * delta#lerp(acceleration,impulse_type,.07) # smooth
	ScreenDebugger.dict["Acceleration"] = acceleration
	
	# this is a interpolation so make sure acceleration is never 0
	# or else the kart will never stop
	hvel = hvel.linear_interpolate(target, acceleration)
	if Input.is_action_just_pressed("cmd_trigger_right") or do_turbo:
		hvel *= 2
		do_turbo = false
	ScreenDebugger.dict["hvel"] = hvel
	
	# Assign hvel's values back to velocity, and then move.
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	
#	velocity += -$mesh.global_transform.basis.y 
	velocity = move_and_slide_with_snap(velocity,normal,Vector3.UP,false)
#	velocity = move_and_slide(velocity,Vector3.UP,true,4,PI/3)
	
	speed = Vector2(velocity.x,velocity.z).length()
	ScreenDebugger.dict["Velocity"] = velocity
	ScreenDebugger.dict["Turning"] = turning
	ScreenDebugger.dict["Speed"] = speed

func do_gas():
	while true:
		if gas < 1:
			gas += _delta
		ScreenDebugger.dict["gas"] = gas
		yield(get_tree(),"idle_frame")
