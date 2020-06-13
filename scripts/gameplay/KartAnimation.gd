extends Spatial
class_name KartAnimation

onready var tires = [
	$center/kart/tires/tire_bl,
	$center/kart/tires/tire_br,
	$center/kart/tires/tire_fl,
	$center/kart/tires/tire_fr,
]

onready var marks = [
	$center/kart/tires/fl/trail,
	$center/kart/tires/fr/trail,
	$center/kart/tires/bl/trail,
	$center/kart/tires/br/trail,
]

onready var center:Spatial = $center
onready var kart = get_parent()
var center_target_rot = 0
var t = 1

func tire_mark_slide(activate:bool):
	for mark in marks:
		mark.emit = activate

func tire_mark_brake(activate:bool):
	marks[2].emit = activate
	marks[3].emit = activate

func _process(delta):
	
	var speed = (kart.speed)
	tires[0].rotation_degrees.x -= speed
	tires[1].rotation_degrees.x += speed
	tires[2].rotation_degrees.x -= speed
	tires[3].rotation_degrees.x -= speed
	rotate_front_tires([tires[2],tires[3]])
	
	
	center_target_rot = 10 * sign(kart.turning)
	
	center.rotation_degrees.y = lerp(center.rotation_degrees.y, center_target_rot,.2)
	
	
	#kart sliding animation
	if kart.sliding:
		$center.rotation_degrees.y = lerp($center.rotation_degrees.y,80 * kart.sliding_side,.3)
		pass
	
	# Kart inclination animation when jumping
#	if not kart.is_on_floor() and kart.speed > 2:
#
#		while(!kart.is_on_floor()):
#			t -= delta
#			if t > 0: 
#				yield(get_tree(),"idle_frame")
#				continue
#			$center.rotation_degrees.z = lerp($center.rotation_degrees.z,20,.2)
#			yield(get_tree(),"idle_frame")
#		$center.rotation_degrees.z = 0
#		t = 1
		
		


func rotate_front_tires(ftires):
	for tire in ftires:
		tire.rotation_degrees.y = lerp(tire.rotation_degrees.y,kart.tire_rot * 45,.2)
	pass
