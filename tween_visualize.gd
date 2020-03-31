extends Node2D

onready var tween = $Tween
var easing_pairs = [
	[Tween.EASE_IN,"EASE_IN"],
	[Tween.EASE_OUT,"EASE_OUT"],
	[Tween.EASE_IN_OUT,"EASE_IN_OUT"],
	[Tween.EASE_OUT_IN,"EASE_OUT_IN"],
	]
var transition_pairs = [
	[Tween.TRANS_SINE,"SINE"],
	[Tween.TRANS_QUINT,"QUINT"],
	[Tween.TRANS_QUART,"QUART"],
	[Tween.TRANS_QUAD,"QUAD"],
	[Tween.TRANS_EXPO,"EXPO"],
	[Tween.TRANS_ELASTIC,"ELASTIC"],
	[Tween.TRANS_CUBIC,"CUBIC"],
	[Tween.TRANS_CIRC,"CIRC"],
	[Tween.TRANS_BOUNCE,"BOUNCE"],
	[Tween.TRANS_BACK,"BACK"],
	[Tween.TRANS_LINEAR,"LINEAR"],
]
const lScn = preload("res://TweenLine2D.tscn")
const labelScn = preload("res://Label.tscn")
const legendScn = preload("res://Legend.tscn")


export var color_ease_in = Color(0.35,0.85,0.55,0.85) setget set_color_ease_in
export var color_ease_out = Color(0.85,0.45,0.35,0.85) setget set_color_ease_out
export var color_ease_inout = Color(0.35,0.25,0.95,0.85) setget set_color_ease_inout
export var color_ease_outin = Color(0.95,0.45,0.85,0.85) setget set_color_ease_outin

export var row0_y = 100 setget set_row0_y
export var row1_y = 410 setget set_row1_y
export var row2_y = 670 setget set_row2_y
export var charts_offset_x = 30 setget set_charts_offset_x
export var legend_interval_y = 40 setget set_legend_interval_y
export var chart_label_offset = Vector2(-10,0) setget set_chart_label_offset
export var column_spacing = 280 setget set_column_spacing

# Following params will not take effect until you press the "Draw" button again
# This controls the resolution of the curve, higher resolution curves take longer to draw
export var tween_duration = 2.0
export var x_step_curve = 1.8
export var chart_height = 200

func draw_lines():
	render_curves()
	format_charts()


var charts = []

func render_curves():
	for chart in charts:
		chart.queue_free()
	charts = []
	for transition_pair in transition_pairs:
		var chart = []
		for easing_pair in easing_pairs:
			var l = lScn.instance() as Line2D
			if l:
				add_child(l)
				tween.interpolate_method(l,"add_val",chart_height,0,tween_duration,transition_pair[0],easing_pair[0])
				tween.interpolate_callback(l,tween_duration,"show_line",x_step_curve)
				chart.append(l)
		charts.append(chart)
	tween.start()
var chart_elements = []
func format_charts():
	for chart_element in chart_elements:
		chart_element.queue_free()
	chart_elements = []
	var count = 1
	var ofs = Vector2(charts_offset_x,row0_y)
	var ofs_step = Vector2(column_spacing,0.0)
	for chart in charts:
		if count % 3 == 2:
			ofs = Vector2(ofs.x,row2_y)
		elif count % 3 == 1:
			ofs = Vector2(ofs.x,row1_y)
		else:
			ofs = Vector2(ofs.x,row0_y)
		for i in chart.size():
			var curve = chart[i]
			curve.position = ofs
			curve.default_color = index_to_color(i)
		var chart_label = labelScn.instance() as Label
		if chart_label:
			add_child(chart_label)
			chart_elements.append(chart_label)
			chart_label.text = transition_pairs[count - 1][1]
			chart_label.rect_position = ofs + chart_label_offset
		if count % 3 == 2:
			ofs += ofs_step
		count += 1
	ofs = Vector2(charts_offset_x,row0_y)
	for i in easing_pairs.size():
		var legend = legendScn.instance() as Control
		if legend:
			add_child(legend)
			chart_elements.append(legend)
			legend.rect_position = ofs
			ofs.y += legend_interval_y
			legend.set_color(index_to_color(i))
			legend.set_text(easing_pairs[i][1])

func _on_Button_pressed():
	draw_lines()

func index_to_color(i):
	match i:
		0:
			return color_ease_in
		1:
			return color_ease_out
		2:
			return color_ease_inout
		3:
			return color_ease_outin
func set_color_ease_in(val):
	color_ease_in = val
	format_charts()
func set_color_ease_out(val):
	color_ease_out = val
	format_charts()
func set_color_ease_inout(val):
	color_ease_inout = val
	format_charts()
func set_color_ease_outin(val):
	color_ease_outin = val
	format_charts()

func set_row0_y(val):
	row0_y = val
	format_charts()
func set_row1_y(val):
	row1_y = val
	format_charts()
func set_row2_y(val):
	row2_y = val
	format_charts()
func set_charts_offset_x(val):
	charts_offset_x = val
	format_charts()
func set_legend_interval_y(val):
	legend_interval_y = val
	format_charts()
func set_chart_label_offset(val):
	chart_label_offset = val
	format_charts()
func set_column_spacing(val):
	column_spacing = val
	format_charts()
