extends TextureButton
var called = false
var p = 0
var q = 0
var has_played = false
var ready_to = 0
var played = false
var loaded = false
func _ready():
	get_parent().get_child(9).visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func choice(choice):
	if choice == "play":
		play()
	if choice == "quit":
		quit()
	if called:
		return
		get_parent().get_child(8).play(0.0)
		called = true

func play_cursor(item):
	if item == "play":
		if p < 1:
			get_parent().get_child(7).play(0.0)
			p += 1
	if item == "quit":
		if q < 1:
			get_parent().get_child(7).play(0.0)
			q += 1
	else:
		has_played = true
func play_shot():
	if played:
		return
	else:
		get_parent().get_child(8).play(0.0)
		played = true
func play():
	get_parent().get_child(9).visible = true
	get_parent().get_child(9).play("play")

	ready_to = 1
func quit():
	get_parent().get_child(9).visible = true
	get_parent().get_child(9).play("quit")
	
	ready_to = 2

func _process(delta):

	if (.is_hovered() and $".".name == "Playagain"):
		.get_child(0).expand = true
		play_cursor("play")
		
	if (!.is_hovered() and $".".name == "Playagain"):
		$P.expand = false
		p = 0
	if (.is_hovered() and $".".name == "Quit"):
		.get_child(0).expand = true
		play_cursor("quit")
		
	if (!.is_hovered() and $".".name == "Quit"):
		.get_child(0).expand = false
		q = 0
	
	if $".".name == "Playagain" and $".".is_pressed():
		choice("play")
		play_shot()
		
	if $".".name == "Quit" and ($".".is_pressed()):
		choice("quit")
		play_shot()
	if Input.is_action_just_pressed("esc"):
		choice("quit")
		
	if ready_to == 1 and get_parent().get_child(9).frame == 7:
		$"/root/savedfiles".loaded = true
		$"/root/savedfiles".player_in_pos = false
		$"/root/savedfiles".load_game()
		Global.spawn_boss = false
	if ready_to == 2 and get_parent().get_child(9).frame == 7:
		get_tree().quit()
