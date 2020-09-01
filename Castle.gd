extends Spatial

const MOB = preload("res://castleknight.tscn")
var cur_scene
var start_theme = false
var can_quit
var quit_timer = 0
var scene 
var passed = false
var spawned = false
var spawned2 = false
var spawned3 = false
var spawned4 = false
var spawned5 = false
var patience = 0
var char_in_pos = false
var kingready = false
var trapdoor = false
var released = false
func _ready():
	scene = "Castle.tscn"
	
func spawn_mob(area):
	if area == "a1" and spawned == false:
		var mob = MOB.instance()
		mob.global_transform = $Spawn.global_transform
		add_child(mob)
		$Stairmesh.queue_free()
		$Jails.queue_free()
		spawned = true
	if area == "a2" and spawned2 == false:
		var mob = MOB.instance()
		mob.global_transform = $Spawn2.global_transform
		add_child(mob)
		$Objects.queue_free()
		spawned2 = true
	if area == "a3" and spawned3 == false:
		var mob = MOB.instance()
		mob.global_transform = $Spawn3.global_transform
		add_child(mob)
		spawned3 = true
	if area == "a4" and spawned4 == false:
		var mob = MOB.instance()
		mob.global_transform = $Spawn4.global_transform
		add_child(mob)
		spawned4 = true
	if area == "a5" and spawned5 == false:
		var mob = MOB.instance()
		mob.global_transform = $Spawn5.global_transform
		add_child(mob)
		spawned5 = true

func start_b_music():
	pass
func origin_music():	
	if $"/root/Global".in_cutscene:
		$Dungeon.stop()

	if $Dungeon.playing:
		return
	else:
		$Dungeon.play(0.0)
		
func main_theme():
	if $maintheme.playing:
		return
	else:
		$maintheme.play(0.0)
func atmos():
	if $"/root/Global".in_cutscene:
		$atmos.stop()

	if $atmos.playing:
		return
	else:
		$atmos.play(0.0)

func release():
	if released:
		return
	else:
		get_child(1).in_cutscene = false
		$trapdoor.queue_free()
		released = true

func _process(delta):
	if start_theme:
		main_theme()
	if not ($maintheme.volume_db > -3 and $maintheme.volume_db < -2) and start_theme:
		$maintheme.volume_db += 0.01
	if $maintheme.volume_db > -20:
		$Dungeon.volume_db -= 0.05
		
	if trapdoor == true:
		release()
	patience += 1
	if kingready:
		$Extra/king.move()
	if patience == 3000 and not passed:
		var mob = MOB.instance()
		mob.global_transform = $Spawn6.global_transform
		mob.see_player = true
		add_child(mob)
	$"/root/Global".current_scene = scene
	if not $maintheme.volume_db > -3:
		origin_music()
		atmos()
	if get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if get_tree().paused == false:
		can_quit = true
	else:
		can_quit = false
	
	if can_quit == true:
		quit_timer += 1
	else:
		quit_timer = 0
	if Input.is_action_just_pressed("esc") and quit_timer > 10:
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept") and quit_timer > 10:
		pass

	
func _on_Area1_body_entered(body):
	if "CPlayer" in body.name:
		spawn_mob("a1")


func _on_Area2_body_entered(body):
	if "CPlayer" in body.name:
		spawn_mob("a2")


func _on_Area3_body_entered(body):
	if "CPlayer" in body.name:
		spawn_mob("a3")
		spawn_mob("a4")


func _on_Area4_body_entered(body):
	if "CPlayer" in body.name:
		spawn_mob("a5")


func _on_Area_body_entered(body):
	if "CPlayer" in body.name:
		start_theme = true
		passed = true
