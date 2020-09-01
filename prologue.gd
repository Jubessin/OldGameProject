extends Node2D

var text_timer = 0
var text_timer2 = 0 
var tt = 0
var done = false
var done2 = false
var done3 = false
var done4 = false
var done5 = false
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$RichTextLabel.visible_characters = 0
	
func add_text(t):
	$RichTextLabel.clear()
	if t == 1:
		$RichTextLabel.add_text("This, is a tale of justice...")

	if t == 2:
		$RichTextLabel.add_text("But it is also a tale of revenge...")

	if t == 3:
		$RichTextLabel.add_text("With false accusation, this quest begins...")
	
	if t == 4:
		$RichTextLabel.add_text("To right wrongs, is your noble goal...")
	
	if t == 5:
		$RichTextLabel.add_text("As this, is to which you are destined....")

func play_theme():
	if $AudioStreamPlayer2D.playing:
		return
	else:
		$AudioStreamPlayer2D.play(0.0)
func _process(delta):
	play_theme()
	print($RichTextLabel.visible_characters)
	text_timer2 += 1
	if text_timer2 == 50:
		add_text(1)
	if text_timer2 == 300:
		$RichTextLabel.visible_characters = 0
		add_text(2)
	if text_timer2 == 750:
		$RichTextLabel.visible_characters = 0
		add_text(3)
	if text_timer2 == 1150:
		$RichTextLabel.visible_characters = 0
		add_text(4)
	if text_timer2 == 1550:
		$RichTextLabel.visible_characters = 0
		add_text(5)
	if text_timer2 == 2050:
		done = true
	text_timer += 1
	if text_timer == 6 and not done:
		if $RichTextLabel.visible_characters < 70:
			$RichTextLabel.visible_characters += 1
		text_timer2 += 1
	if text_timer == 7 and not done:
		text_timer = 0
	if text_timer == 20 and done:
		$RichTextLabel.visible_characters -= 1
	if text_timer == 21 and done:
		text_timer = 0
	if $RichTextLabel.visible_characters == -10 and done:
		Global.next_map = "Castle.tscn"
		get_tree().change_scene("Loadingscreen.tscn")
	
#	if $RichTextLabel.get_total_character_count() == $RichTextLabel.get_visible_line_count():
#		$RichTextLabel.visible_characters = 0