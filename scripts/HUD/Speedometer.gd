extends Control
class_name Speedometer

export var np_kart:NodePath
var kart:KartState
const MIN:float = -61.0
const MAX:float = 72.0
#-129 -22
func _ready():
	kart = get_node(np_kart)
	# MAX_kartT_SPEED - 100
	# x - speed
	#s*M = 100*x -- x = s*M/100

func _process(delta):
	var value = (kart.speed * kart.MAX_KART_SPEED) / 100
	ScreenDebugger.dict["value"] = value
	$Pointer.rect_rotation = get_value(value)
	
	if is_equal_approx(kart.gas,0):
		$Gas.modulate = Color.green
		$Gas.margin_left = -22
	else:
		if kart.gas > .5:
			$Gas.modulate = Color.red
		$Gas.margin_left = -get_gas_percentage(kart.gas)

	#resultado tem que ser 5.5

#input should be between 0-100
func get_value(input:float):
	if is_equal_approx(input,0) or input < 0: return MIN
	if is_equal_approx(input,100) or input > 100: return MAX 
	return (((input - 0) * ( MAX - MIN )) / (100-0)) + MIN

func get_gas_percentage(input:float):
	if is_equal_approx(input,0) or input < 0: return 22
	if is_equal_approx(input,1) or input > 1: return 119
	return (((input - 0) * ( 119 - 22 )) / (1-0)) + 22 
