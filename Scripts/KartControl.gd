extends KinematicBody
class_name KartControl



export var max_speed:float = 50
export var turn_speed:float = 7
export var jump_force:float = 21
export var acc:float = .05
export var deacc:float = .05
export var gravity:float = 80
var velocity:Vector3
var max_turn:float = 180
var hspeed = 0
var accelerating:int = 0
var hvelocity:float = 0
var turning:float = 0
var _turn:float = 0
var _actual_turn:float = 0
var keys = []
var smooth_keys = []
var jumped = false
var sliding = false
var can_turbo = false
var turbo_count:int = 0
var delta:float = 0
var can_jump:bool = false
var is_grounded:bool = false
onready var tire_tr = $KartBody/tire_tr
onready var tire_tl = $KartBody/tire_tl
onready var tire_bl = $KartBody/tire_bl
onready var tire_br = $KartBody/tire_br
onready var body:Spatial = $KartBody
onready var anim_body:AnimationPlayer = $KartBody/AnimationPlayer
onready var initial_pos = translation
onready var sfx:AudioStreamPlayer3D = $sfx
var smooth_right:float = 0
var smooth_left:float = 0
#meter
var meter_height:float = 0
var meter_slide:float = 0 
var stop_meter_slide:bool = false
var ray:RayCast

func _ready():
	ray = RayCast.new()
	ray.set_cast_to(Vector3(0,-5,0))
	ray.enabled = true
	get_parent().call_deferred("add_child",ray)

func _process(delta):
	self.delta = delta
	ray.global_transform.origin = global_transform.origin
	ray.force_raycast_update()
	
func _physics_process(delta):
	
	keys = [
		int(Input.is_action_pressed("ui_up")),
		int(Input.is_action_pressed("ui_down")),
		int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_right"))
	]

#	var normal = Vector3.ZERO
	is_grounded = $RayNormal.is_colliding()
	
	
	var n1norm = transform.basis.y
	var n2norm = $RayNormal.get_collision_normal()
	

	
	var cosa = n1norm.dot(n2norm)
	
	var alpha = acos(cosa)
	
	var axis = n1norm.cross(n2norm)
	axis = axis.normalized()
	
	var t = transform.rotated(axis, alpha)
	$Spatial.transform = t
	Debugger.print_screen("tr",t)
	rotation_degrees = lerp(rotation_degrees,$Spatial.rotation_degrees,0.2)
#	global_transform.basis.slerp($Spatial.get_global_transform().basis,.2)
	if is_on_floor():
		accelerating = keys[0] - keys[1]

	if Input.is_action_just_pressed("ui_accept"): 
		translation = initial_pos
		velocity = Vector3.ZERO
		sliding = false
		jumped = false

	rotation_system()

	hspeed = lerp(hspeed,max_speed * accelerating + (int(can_turbo) * 200 + (turbo_count * 10) ),get_factor())

	var desired_velocity =  hspeed * get_global_transform().basis.z
	velocity.x = desired_velocity.x
	velocity.y -= gravity * delta
	velocity.z = desired_velocity.z
	
	if Input.is_action_just_pressed("tr_left") && is_grounded:
		print("jumpesd")
		velocity.y = jump_force
		jumped = true
		sliding = false
		anim_body.play("Jump")
	
	

	if is_grounded && jumped && velocity.y > .1 && Input.is_action_pressed("tr_left"): 
		sliding = true
		jumped = false
	
	Debugger.print_screen("velocityH",hvelocity)
#	Debugger.print_screen("velocity%",hvelocity / max_speed)
#	Debugger.print_screen("floorNormal",$RayNormal.get_collision_normal())
	Debugger.print_screen("gravity",velocity.y)
	Debugger.print_screen("turning",turning)
	Debugger.print_screen("jumped",jumped)
	Debugger.print_screen("can_jump",can_jump)
	Debugger.print_screen("grounded",is_grounded)
	Debugger.print_screen("sliding",sliding)
	Debugger.print_screen("can_turbo",can_turbo)
	Debugger.print_screen("sliding",sliding)
	Debugger.print_screen("bodyRot",body.rotation_degrees.y)
	Debugger.print_screen("sliding_meter",meter_slide)
	Debugger.print_screen("velocityH",hvelocity)
	Debugger.print_screen("turboCount",turbo_count)
	velocity = move_and_slide(velocity,Vector3.UP,true,4,PI/4,false)
	hvelocity = abs ( velocity.length() )
	pass

func rotation_system():
	if bool(keys[3]):
		smooth_right = lerp(smooth_right,keys[3],.01)
	else:
		smooth_right = lerp(smooth_right,0,.1)
	if bool(keys[2]):
		smooth_left = lerp(smooth_left,keys[2],.01)
	else:
		smooth_left = lerp(smooth_left,0,.1)
	
	turning = smooth_left - smooth_right
	rotate_y(turning * .05)
	rotate_tires()

func rotate_tires():
	tire_tl.rotation_degrees.y = turning * 45
	tire_tr.rotation_degrees.y = tire_tl.rotation_degrees.y
	pass

func switch_turbo():
	body.pfire_emit_all()
	can_turbo = true
	yield(get_tree().create_timer(.1,false),"timeout")
	can_turbo = false

func get_factor() -> float:
	if accelerating == 0:
		return deacc
	else: return acc

func rotate_towards(dest_angle:float):
	var slope_rot = $RayNormal.get_collision_normal()
	pass
#	body.rotation_degrees = Quat(transform).slerp()
#	body.rotation_degrees.y = lerp(body.rotation_degrees.y,125,.002)

