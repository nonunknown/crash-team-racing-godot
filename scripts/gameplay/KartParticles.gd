extends Spatial
class_name KartParticles

onready var mat:SpatialMaterial = $Smoke/Particles.draw_pass_1.surface_get_material(0)


func set_smoke_black():
	print(str(mat.get_property_list()))
	mat.params_blend_mode = 2
	pass

func set_smoke_white():
	mat.params_blend_mode = 1
	pass
