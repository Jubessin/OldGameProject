extends Spatial

var timer = 0
func _ready():
	$Player/head/Camera.far = 2020
	$Player.in_cutscene = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += 1
#	print($Camera.translation.z)
	if not ($Player.translation.z > -946.5 and $Player.translation.z < -942.5):
		if timer < 10:
			$Player.translation.z -= 0.3
		if timer >= 10 and timer < 20:
			$Player.translation.z -= 0.5
		if timer >= 20 and timer < 40:
			$Player.translation.z -= 0.7
		if timer >= 40 and timer < 70:
			$Player.translation.z -= 1.2
		if timer >= 70 and timer < 110:
			$Player.translation.z -= 1.7
		if timer >= 110 and timer < 150:
			$Player.translation.z -= 2.2
		if timer >= 150 and timer < 175:
			$Player.translation.z -= 3.7
		if timer >= 175:
			$Player.translation.z -= 4.7
	if $Player.translation.z > -946.5 and $Player.translation.z < -942.5:
		Global.next_map = "cave.tscn"
		get_tree().change_scene("Loadingscreen.tscn")