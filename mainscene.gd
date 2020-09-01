extends Spatial

const MOB = preload("res://1stknight.tscn")
var cur_scene
var can_quit
var quit_timer = 0
var bar_shown = false
const BOSSBAR = preload("res://bossprogressbar.tscn")
const CUTSCENE = preload("res://showBoss.tscn")
const BOSS = preload("res://Bossmob.tscn")
var boss_timer = 0
var scene 
func _ready():
	var mob = MOB.instance()
	scene = "cavemap.tscn"
	
	
func show_bar():
	var bossbar = BOSSBAR.instance()
	if bar_shown == true:
		return
	else:
		get_child(1).add_child(bossbar)
		bar_shown = true
func start_b_music():
	if $boss.playing:
		return
	else:
		$boss.play(0.0)
func origin_music():	
	if $"/root/Global".in_cutscene:
		$AudioStreamPlayer.stop()
		
		
	if $AudioStreamPlayer.playing:
		return
	else:
		$AudioStreamPlayer.play(0.0)
func atmos():
	if $"/root/Global".in_cutscene:
		$atmos.stop()
		
		
	if $atmos.playing:
		return
	else:
		$atmos.play(0.0)
func _process(delta):
	$"/root/Global".current_scene = scene
	if $Player.is_resting or get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if get_tree().paused == false:
		can_quit = true
	else:
		can_quit = false
		
	if Global.spawn_boss == true:
		boss_timer += 1
	if boss_timer == 50:
		var boss = BOSS.instance()
		boss.global_transform = $Spatial.global_transform
		add_child_below_node($Player, boss)
		$Spatial.queue_free()
		$Player.in_cutscene = false
	
	if can_quit == true:
		quit_timer += 1
	else:
		quit_timer = 0
	if Input.is_action_just_pressed("esc") and quit_timer > 10:
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept") and quit_timer > 10:
		pass
	if get_child(2).name == "Bossmob":
		if $Bossmob.see_player:
			show_bar()
			$AudioStreamPlayer.stop()
			$atmos.stop()
			start_b_music()
			
	if not get_child(2).name == "Bossmob":
		$boss.stop()
		origin_music()
		atmos()
	

func _on_Cutscene_body_entered(body):
	if not Global.boss_killed == true:
		var cutscene = CUTSCENE.instance()
		if get_child(1).name in body.name:
			.add_child(cutscene)
			Global.in_cutscene = true
			Global.cutscene = "Boss"
			$Cutscene.queue_free()
