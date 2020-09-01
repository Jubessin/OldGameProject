extends Node2D
var anim_timer = 0
var save_timer = 0
var start = false
var move_down = false
var timer = 0
var quit_timer = 0
var quitting = false
var save_data
var cont = false
var continue_timer = 0
var shot_played = false
var has_played = false
var y = 0
var n = 0
func _ready():
	get_parent().get_parent().is_resting = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$AnimatedSprite.speed_scale = 0.7
	$AnimatedSprite.play("default")
	$Title.hide()
	$Yes.hide()
	$No.hide()
	$sword.hide()
	$saving.hide()
	$Continue.hide()
	$quitting.hide()
	$Particles2D.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func menu_select():
	if shot_played:
		return
	if shot_played == false:
		$shot.play(0.0)
		shot_played = true
func menu_hover(item):
	if item == "yes":
		if y < 1:
			$cursor.play(0.0)
			y += 1
	if item == "no":
		if n < 1:
			$cursor.play(0.0)
			n += 1
	else:
		has_played = true
func _process(delta):
	if cont == true:
		continue_timer += 1
	if continue_timer == 100:
		self.queue_free()
	anim_timer += 1
	if start == true:
		save_timer += 1
	if save_timer > 200:
		timer += 1
	if quitting == true:
		quit_timer += 1
	if quit_timer == 70:
		$Continue.queue_free()
	if quit_timer == 130:
		$Particles2D.emitting = true
		$No.queue_free()
	if quit_timer == 240:
		$Yes.queue_free()
	if quit_timer == 330:
		$quitting.show()
	if quit_timer == 400:
		$quitting.queue_free()
		
	if quit_timer == 480:
		get_tree().quit()
		
	if anim_timer > 90:
		$AnimatedSprite.play("finish")
	if anim_timer > 140 and not save_timer > 140 :
		$Title.show()
	if anim_timer > 200 and not save_timer > 140:
		$Yes.show()
	if anim_timer > 235 and not save_timer > 140:
		$No.show()
	if anim_timer > 275:
		$sword.show()
	
	if not save_timer > 140:
		if $Yes.is_hovered():
			$Yes/TextureRect.expand = true
			menu_hover("yes")
		else:
			$Yes/TextureRect.expand = false
			y = 0
			
		if $No.is_hovered():
			$No/TextureRect.expand = true
			menu_hover("no")
		else:
			n = 0
			$No/TextureRect.expand = false
			
		if $Yes.pressed:
			menu_select()
			$"/root/savedfiles".save_game()
			$saving.show()
			start = true
		if $No.pressed:
			menu_select()
			start = true
	if save_timer == 200:
		$Title.queue_free()
		$Yes.hide()
		$No.hide()
		$saving.queue_free()
		shot_played = false
	if quitting == false:	
		if !move_down == true:
			$Continue.position.y -= 0.2
		if move_down == true:
			$Continue.position.y += 0.2
		if timer > 50:
			$Continue.show()
	if timer >= 0 and quitting == false:
		if $Continue.position.y > 385 and $Continue.position.y < 386:
			move_down = true
		if $Continue.position.y < 420 and $Continue.position.y > 419:
			move_down = false
	if timer > 100 and quitting == false:
		if timer > 100:
			$Yes.show()
		if timer > 125:
			$No.show()
		if $Yes.is_hovered():
			$Yes/TextureRect.expand = true
			menu_hover("yes")

		else:
			y = 0
			$Yes/TextureRect.expand = false
		
		if $No.is_hovered():
			menu_hover("no")
			$No/TextureRect.expand = true
		else:
			n = 0
			$No/TextureRect.expand = false
		if $Yes.pressed:
			menu_select()
			get_parent().get_parent().is_resting = false
			get_parent().get_parent().rested = true
			cont = true
		if $No.pressed:
			menu_select()
			quitting = true