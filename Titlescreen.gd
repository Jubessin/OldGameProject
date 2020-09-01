extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = false
var timer = 0
var has_played = false
var cursor_on
var ng = 0
var lo = 0
var op = 0
var qu = 0
var fade = false
var fade_type 
var fade_timer = 0
var ng_start = false
var lg_start = false
var q_start = false
var shot_played = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$cursor.bus = "SFX"
	$thunder.bus = "SFX"
	$sword.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"black screen2".visible = false
	$newgame.visible = false
	$options.visible = false
	$Load.visible = false
	$quit.visible = false
	$WorldEnvironment.environment.adjustment_enabled = true
func play_theme():
	if $AudioStreamPlayer.playing:
		return
	else:
		$AudioStreamPlayer.play(0.0)
func ambiance():
	if $thunder.playing or $Particles.emitting == false:
		return
	else:
		$thunder.play(0.0)
func play_cursor(item):
	if item == "newgame":
		if ng < 1:
			$cursor.play(0.0)
			ng += 1
	if item == "load":
		if lo < 1:
			$cursor.play(0.0)
			lo += 1
	if item == "options":
		if op < 1:
			$cursor.play(0.0)
			op += 1
	if item == "quit":
		if qu < 1:
			$cursor.play(0.0)
			qu += 1
	else:
		has_played = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func fade(button_pressed):
	if button_pressed == "new_game":
		fade_type = 0
	if button_pressed == "load_game":
		fade_type = 1
	if button_pressed == "quit":
		fade_type = 2
	fade = true
	if !ng_start or !lg_start or !q_start:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$sword.hide()
		if shot_played == false:
			$shot.play(0.0)
			shot_played = true
	
	
func _process(delta):
	if fade:
		if fade and fade_type == 2:
			fade_timer += 1
			$WorldEnvironment.environment.adjustment_brightness -= 0.005
			if fade_timer == 20:
				$newgame.queue_free()
			if fade_timer == 60:
				$Load.queue_free()
			if fade_timer == 100:
				$options.queue_free()
		if fade and fade_type == 1:
			$WorldEnvironment.environment.adjustment_brightness -= 0.001
			fade_timer += 1
			if fade_timer == 50:
				$newgame.queue_free()
			if fade_timer == 100:
				$options.queue_free()
			if fade_timer == 150:
				$quit.queue_free()
		if fade and fade_type == 0:
			$WorldEnvironment.environment.adjustment_brightness -= 0.001
			fade_timer += 1
			if fade_timer == 50:
				$Load.queue_free()
			if fade_timer == 100:
				$options.queue_free()
			if fade_timer == 150:
				$quit.queue_free()
		if $WorldEnvironment.environment.adjustment_brightness > 0.01 and $WorldEnvironment.environment.adjustment_brightness < 0.02 and fade_type == 0:
			ng_start = true
		if $WorldEnvironment.environment.adjustment_brightness > 0.01 and $WorldEnvironment.environment.adjustment_brightness < 0.02 and fade_type == 1:
			lg_start = true
		if $WorldEnvironment.environment.adjustment_brightness > 0.01 and $WorldEnvironment.environment.adjustment_brightness < 0.02 and fade_type == 2:
			q_start = true
		if not fade_type == 2:
			if $AudioStreamPlayer.volume_db > -32:
				$AudioStreamPlayer.volume_db -= 0.03
		else:
			if $AudioStreamPlayer.volume_db > -32:
				$AudioStreamPlayer.volume_db -= 0.1
	play_theme()
	ambiance()
	if start == true:
		if not $stars.opacity > 0.98:
			$stars.opacity += 0.0007
		$WorldEnvironment.environment.background_sky_rotation.y -= 0.0001
		if not $WorldEnvironment.environment.adjustment_brightness < 0.4 and not fade == true:
			$WorldEnvironment.environment.adjustment_brightness -= 0.0006
	if start == false:
		if not $stars.opacity < 0:
			$stars.opacity -= 0.0009
		$WorldEnvironment.environment.background_sky_rotation.y += 0.0001
		if not $WorldEnvironment.environment.adjustment_brightness > 0.9 and not fade == true:
			$WorldEnvironment.environment.adjustment_brightness += 0.0008
	if $WorldEnvironment.environment.background_sky_rotation.y > 0.4 and $WorldEnvironment.environment.background_sky_rotation.y < 0.5:
		start = true
	if $WorldEnvironment.environment.background_sky_rotation.y > -0.5 and $WorldEnvironment.environment.background_sky_rotation.y < -0.4:
		start = false
	if !fade:
		if $AudioStreamPlayer.volume_db < -5:
			$AudioStreamPlayer.volume_db += 0.01
		timer += 1
		if timer == 100:
			$"newgame".visible = true
		if timer == 150:
			$"Load".visible = true
		if timer == 200:
			$"options".visible = true
		if timer == 300:
			$"quit".visible = true
		if timer == 400:
			$"black screen2".visible = true
		if timer == 450:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			$sword.visible = true
		
		if $"newgame".is_hovered():
			$"newgame/newgame".expand = true
			play_cursor("newgame")
			
		else:
			$"newgame/newgame".expand = false
			ng = 0
			
		if $"Load".is_hovered():
			$"Load/Load".expand = true
			play_cursor("load")
			
		else:
			$"Load/Load".expand = false
			lo = 0
			
		if $"options".is_hovered():
			$"options/options".expand = true
			play_cursor("options")
		
		else:
			$"options/options".expand = false
			op = 0
		if $"quit".is_hovered():
			$"quit/quit".expand = true
			play_cursor("quit")
			
		else:
			$"quit/quit".expand = false
			qu = 0
		if $newgame.pressed:
			fade('new_game')
		if $Load.pressed:
			fade('load_game')
		if $options.pressed:
			Global.previous_scene = "Titlescreen.tscn"
			get_tree().change_scene("options.tscn")
		if $"quit".pressed or Input.is_action_just_pressed("esc"):
			fade('quit')
			
			
	
	
	if ng_start:
		$"/root/savedfiles".new_game()
	if lg_start:
		$"/root/savedfiles".load_game()
	if q_start:
		get_tree().quit()