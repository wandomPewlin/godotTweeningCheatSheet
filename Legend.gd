extends Control


func _ready():
	pass # Replace with function body.

func set_color(col):
	$Label2.self_modulate = col
	$ColorRect.color = col
func set_text(txt):
	$Label2.text = txt
