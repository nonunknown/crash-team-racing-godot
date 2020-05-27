extends KartController
class_name KartState

enum STATE {IDLE,MOVING,JUMP,AIR,SLIDING}
var state_machine:StateMachine

func _ready():
	state_machine = StateMachine.new(self)
	
	state_machine.register_state_array([
		STATE.IDLE,STATE.MOVING,STATE.JUMP,STATE.AIR,STATE.SLIDING
		],["idle","moving","jump","air","sliding"])
	
	state_machine.start()

func _process(delta):
	state_machine.machine_update()
	
	#debugging
	ScreenDebugger.dict["STATE"] = STATE.keys()[state_machine.get_current_state()]



func cd_jump() -> bool:
	if triggers[0] == 1:
		return true
	return false

func cd_moving() -> bool:
	if median_velocity > .2:
		return true
	return false


func st_init_idle():
	print("entered idle")
	pass

func st_update_idle():
	
	if cd_jump(): state_machine.change_state(STATE.JUMP)
	if cd_moving(): state_machine.change_state(STATE.MOVING)
	
	pass

func st_exit_idle():
	pass

func st_init_moving():
	pass

func st_update_moving():
	if !cd_moving(): state_machine.change_state(STATE.IDLE)
	pass

func st_exit_moving():
	pass

func st_init_jump():
	_do_jump = true
	pass

func st_update_jump():
	if _do_jump == false:
		if !$RayCast.is_colliding():
			state_machine.change_state(STATE.AIR)
		else:
			state_machine.change_state(STATE.IDLE)
	pass

func st_exit_jump():
	
	pass

func st_init_air():
	pass

func st_update_air():
	if !$RayCast.is_colliding(): return
	
	if cd_moving():
		state_machine.change_state(STATE.MOVING)
	else:
		state_machine.change_state(STATE.IDLE)
	
	pass

func st_exit_air():
	
	pass

func st_init_sliding():
	pass

func st_update_sliding():
	
	pass

func st_exit_sliding():
	
	pass
