#This file is a TEST
# Its objective is read GHOST DATA
# generated by CTR
extends Control

var ghost_file:String = "ghosts/g_crash_sewer.mcs"
var the_header = ["0xFC","0xFF","0xAC","0x0F","0x08"]
var file_pool:PoolByteArray
func _ready():
	var file:File = File.new()
	var err =  file.open(ghost_file,File.READ)
	var data
	if err == OK:
		file_pool = file.get_buffer(file.get_len())
		var pos = find_header_pos(array_hex_to_int(the_header))
		print("RESULT: "+str(pos))
		print(str(file_pool[pos]))
		print("NEW POOL")
		var new_pool = file_pool.subarray(pos,file.get_len()-1)
#		print(str(new_pool))
		var s = ""
		for value in new_pool:
			s += str(value)+", "
		print(s)
#		for value in header:
#
#			var r= value.hex_to_int()
#			print(value + "=> "+ str(r))
##		ṕprint(str(theint))
#		data = file.get_buffer(file.get_len())
#		var s = data.hex_encode()
#		print(str(s))
	else:
		push_warning("could not read file: "+str(err))

func find_header_pos(header:Array) -> int:
	var pos:int = -1
	var size = header.size()
	for i in range(file_pool.size()):
		if header[0] == file_pool[i]:
			var t = 0
			for j in range(1,size,1):
				if header[j] != file_pool[i+j]: break
				else: t +=1
			if t == size-1: return i
			
				
	
	return pos

func _search():
	
	pass

func array_hex_to_int(arr) -> Array:
	var result = []
	for value in arr:
		result.append(value.hex_to_int())
	print(str(result))
	return result
