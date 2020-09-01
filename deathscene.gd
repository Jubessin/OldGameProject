extends CanvasLayer
var timer = 0
var move_down = false
var p = 0
var q = 0
var has_played = false
func _ready():
	$AudioStreamPlayer.play(0.0)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$AnimatedSprite.visible = false
	$Sprite.visible = false
	$Continue.visible = false
	$Playagain.visible = false
	$Quit.visible = false
	$sword.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	timer += 1
	if $AudioStreamPlayer.volume_db < -10:
		$AudioStreamPlayer.volume_db += 0.1
	if !move_down == true:
		$Continue.position.y -= 0.2
	if move_down == true:
		$Continue.position.y += 0.2
	if timer == 1:
		$AnimatedSprite.visible = true
		$AnimatedSprite.play("default")
	if timer > 63:
		$AnimatedSprite.play("finish")
	if timer > 66:
		$Sprite.show()
	if timer > 145:
		$Sprite.hide()
	if timer > 170:
		$Continue.show()
	if timer > 170:
		if $Continue.position.y > 448 and $Continue.position.y < 449:
			move_down = true
		if $Continue.position.y < 470 and $Continue.position.y > 469:
			move_down = false
	if timer > 290:
		$sword.show()
		$Playagain.show()
		$Quit.show()