extends Spatial

onready var tires = [
	$center/kart/tire_bl,
	$center/kart/tire_br,
	$center/kart/tire_fl,
	$center/kart/tire_fr,
]
onready var center:Spatial = $center
onready var kart_controller:KartController = get_parent()

var center_target_rot = 0
var t = 2
func _process(delta):
	var speed = (kart_controller.speed)
	tires[0].rotation_degrees.x -= speed
	tires[1].rotation_degrees.x += speed
	tires[2].rotation_degrees.x -= speed
	tires[3].rotation_degrees.x -= speed
	rotate_front_tires([tires[2],tires[3]])
	
	
	center_target_rot = 10 * sign(kart_controller.turning)
	
	center.rotation_degrees.y = lerp(center.rotation_degrees.y, center_target_rot,.2)
	
	
	if not kart_controller.is_on_floor() and kart_controller.speed > 2:
		
		while(!kart_controller.is_on_floor()):
			t -= delta
			if t > 0: 
				yield(get_tree(),"idle_frame")
				continue
			$center.rotation_degrees.z = lerp($center.rotation_degrees.z,20,.2)
			yield(get_tree(),"idle_frame")
		$center.rotation_degrees.z = 0
		t = 2


func rotate_front_tires(ftires):
	for tire in ftires:
		tire.rotation_degrees.y = lerp(tire.rotation_degrees.y,kart_controller.tire_rot * 45,.2)
	pass
