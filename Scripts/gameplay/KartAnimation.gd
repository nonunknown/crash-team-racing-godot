extends Spatial

onready var tires = [
	$center/kart/tire_bl,
	$center/kart/tire_br,
	$center/kart/tire_fl,
	$center/kart/tire_fr,
]

onready var kart_controller:KartController = get_parent()

func _process(delta):
	tires[0].rotation_degrees.x -= (kart_controller.speed)
	tires[1].rotation_degrees.x += (kart_controller.speed)
	tires[2].rotation_degrees.x -= (kart_controller.speed)
	tires[3].rotation_degrees.x -= (kart_controller.speed)
	rotate_front_tires([tires[2],tires[3]])
	
#	if not kart_controller.is_on_floor() and kart_controller.speed > 2:
#		while(!kart_controller.is_on_floor()):
#			$center.rotation_degrees.z = lerp($center.rotation_degrees.z,20,.5)
#			yield(get_tree(),"idle_frame")
#		$center.rotation_degrees.z = 0


func rotate_front_tires(ftires):
	for tire in ftires:
		tire.rotation_degrees.y = lerp(tire.rotation_degrees.y,kart_controller.tire_rot * 45,.2)
	pass
