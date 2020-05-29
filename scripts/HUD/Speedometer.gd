extends Control
class_name Speedometer

export var np_kart:NodePath
var kart_controller:KartController
const MIN:float = -61.0
const MAX:float = 72.0

# -61 - 0
# 72 - 1
# 

func _ready():
	kart_controller = get_node(np_kart)
	# MAX_KART_SPEED - 100
	# x - speed
	#s*M = 100*x -- x = s*M/100

func _process(delta):
	var value = (kart_controller.speed * kart_controller.MAX_KART_SPEED) / 100
	ScreenDebugger.dict["value"] = value
	$Pointer.rect_rotation = get_value(value)

	#resultado tem que ser 5.5

#input should be between 0-100
func get_value(input:float):
	if is_equal_approx(input,0) or input < 0: return MIN
	if is_equal_approx(input,100) or input > 100: return MAX 
	return (((input - 0) * ( MAX - MIN )) / (100-0)) + MIN 
