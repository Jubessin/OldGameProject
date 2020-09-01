extends Spatial
var trap = false
var scene
var can_quit
var quit_timer = 0
var random
var number_of_spawns
var boss_health
var boss_base_health
var spawn_delay = 0
var random_spawnt 
var bar_shown = false
var randomized = false
const FDIALOGUE = preload("res://ForestDialogue.tscn")
const PORTAL = preload("res://Portal.tscn")
var boss_spawned = false
var p_spawned = false
func _ready():
	randomize()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	scene = "Future.tscn"
	Global.can_leave = false
	if Global.boss_killed == null:
		Global.boss_killed = false
	
#func set_atmos():
#	if $atmos.playing:
#		return
#	else:
#		$atmos.play(0.0)

func play_theme():
	if $Maintheme.playing:
		return
	else:
		$Maintheme.play(0.0)



	
#func show_bar():
#	if bar_shown == true:
#		return
#	else:
#		get_child(1).add_child(bossbar)
#		bar_shown = true

#func randomize_num_spawns():
#	if not randomized:
#		number_of_spawns = round(rand_range(1, 4))
#		randomized = true
#func spawn_boss():
#	if  Global.boss_killed == false:
#		var boss = FORESTBOSS.instance()
#		boss.global_transform = $Bossp.global_transform
#		boss.see_player = true
#		add_child_below_node(get_child(27), boss)
#		boss_spawned = true


func _process(delta):

	
#	if $Player.get_child(1).get_child_count() == 3:
#		$Player.is_resting = true
#	else:
#		$Player.is_resting = false
				
#	if $Player.is_resting:
#		for i in get_children():
#			if i.name.similarity("NightFMob") > 0.5:
#				i.queue_free()

	if $Player.get_child(1).get_children().has("Rest"):
		$Player.is_resting = true
	
#	
#	if $Player.rested:
#			$Player.is_resting = false
#			for i in $Dayspawns.get_children():
#				var mob = FORESTMOB.instance()
#				mob.global_transform = i.global_transform
#				if not a == 17:
#					add_child(mob)
#					a += 1
#				if a >= 17:
#					$Player.rested = false


	

	

	#Callbacks
#	set_atmos()
	play_theme()
#		night_theme()

	
	if p_spawned:
		$Portal.connect("body_entered", self, "_on_Portal_body_entered")
		$Portal.connect("body_exited", self, "_on_Portal_body_exited")

	$"/root/Global".current_scene = scene
	if $Player.is_resting or get_tree().paused == true:
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




func _on_Portal_body_entered(body):
	if "Player" in body.name:
		$"/root/Global".can_leave = true


func _on_Portal_body_exited(body):
	if "Player" in body.name:
		$"/root/Global".can_leave = false

