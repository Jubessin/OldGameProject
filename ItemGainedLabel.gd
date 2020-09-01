extends Node
var time_to_leave = 0
func _ready():
	pass 
func set_text(text):
	$RichTextLabel.set_text(text)
func _process(delta):
	print('imhere')
	time_to_leave += 1
	if time_to_leave == 60:
		queue_free()
