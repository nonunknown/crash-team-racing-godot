extends AudioStreamPlayer3D
class_name KartSound

const MIN:float = 0.5
const MAX:float = 1.5

onready var kart:KartState = get_parent()

func _process(delta):
	var input = (kart.speed*1)/30
	pitch_scale = Utils.get_between_one(MIN,MAX,input)
	ScreenDebugger.dict["Sinput"] = input
	ScreenDebugger.dict["Sspeed"] = kart.speed
	ScreenDebugger.dict["SMin"] = kart.skill_data._min
	ScreenDebugger.dict["SMax"] = kart.skill_data._sf
	ScreenDebugger.dict["Spith"] = pitch_scale
