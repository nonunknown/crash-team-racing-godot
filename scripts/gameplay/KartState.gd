extends KartController
class_name KartState

enum STATE {IDLE,MOVING,SLIDING,JUMPING,BRAKING}
var machine:StateMachine = StateMachine.new(self)

func _ready():
	var arr = []
	for value in STATE.keys():
		arr.append(value.to_lower())
	machine.register_state_array(STATE.values(),arr)
	machine.start()

func _process(delta):
	is_grounded = is_on_floor()
	machine.machine_update()
#	print("test")
	ScreenDebugger.dict["STATE"] = STATE.keys()[ machine.get_current_state()]

var is_grounded:bool 

func cd_moving() -> bool:
	if speed > 1 && is_grounded:
		return true
	return false

func cd_idle() -> bool:
	if speed < 1 && is_grounded:
		return true
	return false

func cd_brake() -> bool:
	if is_grounded && Input.is_action_pressed("cmd_brake"): 
		return true
	return false

func st_init_idle():
	print("test")
	pass

func st_update_idle():
	action_jump()
	if cd_moving(): machine.change_state(STATE.MOVING)
	pass

func st_exit_idle():
	pass


func st_init_moving():
	pass

func st_update_moving():
	action_jump()
	if cd_idle(): machine.change_state(STATE.IDLE)
	if cd_brake(): machine.change_state(STATE.BRAKING)
	if  is_grounded and Input.is_action_pressed("cmd_trigger_left") and jumping: 
		machine.change_state(STATE.SLIDING)
	pass

func st_exit_moving():
	pass


func st_init_sliding():
	animation.tire_mark_slide(true)
	sliding = true
	sliding_side = input_turn
	if sliding_side == 0:
		sliding_side = -1
	pass

var end_gas:bool = false
func st_update_sliding():
	ScreenDebugger.dict["Turbo"] = turbo
	
	if not end_gas:
		gas += _delta

	if gas > 1:
		gas = 0
		end_gas = true
		return
	elif gas > .5 and Input.is_action_just_pressed("cmd_trigger_right"):
#		particles.set_smoke_black()
		turbo += 1
		reserves += 75 * gas
		
		if turbo == 1:
			base_speed = skill_data._mt1
		elif turbo == 2:
			base_speed = skill_data._mt2
		elif turbo == 3:
			base_speed = skill_data._mt3
			end_gas = true
		
		gas = 0
		return
	elif Input.is_action_just_pressed("cmd_trigger_right"):
		end_gas = true
		gas = 0
		return
	
	if Input.is_action_just_released("cmd_trigger_left"): machine.change_state(STATE.IDLE)
	if cd_idle(): machine.change_state(STATE.IDLE)
	
	
	
	pass

func st_exit_sliding():
	animation.tire_mark_slide(false)
	gas = 0
	turbo = 0
	end_gas = false
	base_speed = skill_data._min
	sliding = false
	pass


func st_init_jumping():
	pass

func st_update_jumping():
	pass

func st_exit_jumping():
	pass

var last_base
func st_init_braking():
	last_base = base_speed
	base_speed = BRAKE_SPEED
	animation.tire_mark_brake(true)
	pass

func st_update_braking():
	
	pass

func st_exit_braking():
	base_speed = last_base
	animation.tire_mark_brake(false)
	pass
