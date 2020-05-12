extends Node

var debbuger = preload("res://resources/Debugger.tscn")
var d
func _ready():
	d = debbuger.instance()
	add_child(d)
	pass # Replace with function body.

func print_screen(name:String,value):
	d.dict[name] = value
