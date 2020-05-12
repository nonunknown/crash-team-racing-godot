extends KartControl
class_name KartState

var machine:MachineManager = MachineManager.new(self)

enum STATE {IDLE,MOVE,JUMP,SLIDING,UNBALANCE}
func _ready():
	machine.register_state_array([STATE.IDLE,STATE.MOVE,STATE.JUMP,STATE.SLIDING,STATE.UNBALANCE],
	["idle","move","jump","sliding","unbalance"])
	machine.register_global_init("init_any")
	machine.register_global_exit("exit_any")
	machine.change_state(STATE.IDLE)

func _process(delta):
	._process(delta)
	machine.machine_update()
	Debugger.print_screen("STATE",STATE.keys()[machine.get_current_state()])

func cd_move() -> bool:
	if hvelocity > 1:
		machine.change_state(STATE.MOVE)
		return true
	return false

func cd_idle() -> bool:
	if hvelocity < 1:
		machine.change_state(STATE.IDLE)
		return true
	return false

func cd_sliding() -> bool:
	if sliding:
		machine.change_state(STATE.SLIDING)
		return true
	return false

func cd_unbalance() -> bool:
	
	return false

func init_any():
	print("started new state")
	pass

func exit_any():
	
	pass

func st_init_idle():
	can_jump = true
	sfx.play_sound(sfx.idle)
	pass

func st_update_idle():
	if cd_move(): return
	pass

func st_exit_idle():
	can_jump = false
	pass

func st_init_move():
	sfx.play_sound(sfx.engine)
	can_jump = true
	pass

func st_update_move():
	print("test")
	var pscale = lerp(1,1.7, ( hvelocity / max_speed) )
	Debugger.print_screen("pitch", pscale)
	sfx.pitch_scale = pscale
	if cd_idle(): return
	if cd_sliding(): return
	pass

func st_exit_move():
	can_jump = false
	sfx.pitch_scale = 1
	pass

func st_init_jump():
	pass

func st_update_jump():
	pass

func st_exit_jump():
	pass

func st_init_sliding():
	sliding = true
	pass

func st_update_sliding():
	
	body.rotation_degrees.y = 125.07 * -sign(turning)
#	$KartBody.ptire_emit_all(true)
	
	if meter_slide <= 100 && !stop_meter_slide && turbo_count <= 3: 
			meter_slide += delta * 50
			
	elif meter_slide >=100 or turbo_count > 3: 
		stop_meter_slide = true
		meter_slide = 0
		turbo_count = 0
	
	if Input.is_action_just_pressed("tr_right") && meter_slide > 60:
		switch_turbo()
		sfx.play_sound(sfx.turbo)
		turbo_count += 1
		meter_slide = 0
	
	if Input.is_action_just_released("tr_left"):
		body.rotation_degrees.y = 180
#		body.ptire_emit_all(false)
		machine.change_state(STATE.MOVE)
	
	if cd_unbalance(): return
	pass

func st_exit_sliding():
	meter_slide = 0
	stop_meter_slide = false
	sliding = false
	pass

func st_init_unbalance():
	pass

func st_update_unbalance():
	pass

func st_exit_unbalance():
	pass
