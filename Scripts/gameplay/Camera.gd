extends Camera

export(String,"follow","attached") var type
export var np_target_pos_close:NodePath
export var np_target_pos_far:NodePath
export var np_target_pos_front_far:NodePath
export var np_target_pos_front_close:NodePath
export var np_look:NodePath
export var offset:Vector3
var close:bool = true setget set_cam_close
var target_pos_close:Position3D
var target_pos_far:Position3D
var target_pos_front_close:Position3D
var target_pos_front_far:Position3D
var look:Spatial
var current_pos:Position3D
func _ready():
	target_pos_close = get_node(np_target_pos_close) 
	target_pos_far = get_node(np_target_pos_far) 
	target_pos_front_far = get_node(np_target_pos_front_far) 
	target_pos_front_close = get_node(np_target_pos_front_close) 
	look = get_node(np_look)
	current_pos = target_pos_close

func set_cam_close(value):
	close = value
	

func _process(delta):
	if Input.is_action_just_pressed("cmd_trigger_lb"): 
		close = !close
		if close: current_pos = target_pos_close
		else: current_pos = target_pos_far
	if Input.is_action_pressed("cmd_trigger_rb"):
		if close: current_pos = target_pos_front_close
		else: current_pos = target_pos_front_far
	elif Input.is_action_just_released("cmd_trigger_rb"):
		if close: current_pos = target_pos_close
		else: current_pos = target_pos_far
	ScreenDebugger.dict["Camera_is_close"] = close
	if type == "attached":
		var pos = current_pos.global_transform.origin
		global_transform.origin = lerp(global_transform.origin,pos,.85)
		look_at(look.global_transform.origin + offset,Vector3.UP)
	else:
		global_transform.origin = current_pos.global_transform.origin + offset
	
