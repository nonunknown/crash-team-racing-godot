extends Area
class_name TurboPad


func _on_TurboPad_body_entered(body):
	if not body is KartController: return
	var kart:KartState = body
	kart.do_turbo = true
	pass # Replace with function body.
