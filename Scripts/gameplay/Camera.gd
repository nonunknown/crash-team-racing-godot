extends Camera

export(String,"follow","attached") var type
export var np_player:NodePath
export var offset:Vector3
var target:Spatial

func _ready():
	target = get_node(np_player)

func _process(delta):
	if type == "attached":
		var pos = target.global_transform.origin
		var position3d = target.get_node("Position3D").global_transform.origin
		global_transform.origin = lerp(global_transform.origin,position3d,.2)
		look_at(pos + offset,Vector3.UP)
	else:
		global_transform.origin = target.global_transform.origin + offset
	
