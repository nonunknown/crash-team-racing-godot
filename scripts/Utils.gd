extends Node

func get_between_one(_min:float,_max:float, input:float):
	if is_equal_approx(input,0) or input < 0: return _min
	if is_equal_approx(input,1) or input > 1: return _max
	return (((input - 0) * ( _max - _min )) / (1-0)) + _min

func get_between_hundred(_min:float,_max:float, input:float):
	if is_equal_approx(input,0) or input < 0: return _min
	if is_equal_approx(input,100) or input > 100: return _max
	return (((input - 0) * ( _max - _min )) / (100-0)) + _min

# 1 - 1
# x - 0.5
# (10*.5)/1=x
