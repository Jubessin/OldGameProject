extends CanvasLayer
var timer = 0
var timer2 = 0
func _ready():
	$metaltaur.hide()
	$metaltaursaying.hide()
	$AnimatedSprite.hide()
	$Face.play("default")
func play_walk():
	if $Walkin.playing:
		return
	else:
		$Walkin.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(timer2)
	timer2 += 1
	if timer2 == 1:
		play_walk()
	
	if $Walkin.playing == false:
		timer += 1
	if timer == 125:
		$AnimatedSprite.show()
		$AnimatedSprite.play("default")
	if timer == 175:
		$Laser.play(0.0)
	if timer == 200:
		$metaltaur.show()
	if timer == 270:
		$Soul.play(0.0)
	if timer == 545:
		$AudioStreamPlayer.play(0.0)
		$metaltaursaying.show()
	if timer == 820:
		Global.in_cutscene = false
		Global.spawn_boss = true
	if timer == 825:
		self.queue_free()