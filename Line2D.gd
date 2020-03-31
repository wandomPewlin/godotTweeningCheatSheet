extends Line2D

var vals = []


func add_val(v):
	vals.append(v)

func show_line(interval = 8.0):
	var x = 0.0
	for v in vals:
		add_point(Vector2(x,v))
		x += interval
