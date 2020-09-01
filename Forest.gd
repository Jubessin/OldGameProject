extends Spatial
const FORESTMOB = preload("res://ForestMob.tscn")
const NIGHTMOB = preload("res://NightFMob.tscn")
const BOSSBAR = preload("res://bossprogressbar.tscn")
var trap = false
var spawned = false
var spawned2 = false
var nspawned = false
var dspawned = true
var scene
var can_quit
var quit_timer = 0
var env_timer = 0
var fog_timer = 0
var fog_timeout = 0
var random
var is_day = true
var is_night = false
var day_timer = 0
var night_timer = 0
var day_random
var night_random 
var day_randomized = false
var night_randomized = false
var night_t_start = false
var day_t_start = false
var number_of_spawns
var boss_health
var boss_base_health
var spawn_delay = 0
var random_spawnt 
var bar_shown = false
var randomized = false
const FORESTBOSS = preload("res://ForestBoss.tscn")
const GOODKNIGHT = preload("res://GoodKnight.tscn")
const FDIALOGUE = preload("res://ForestDialogue.tscn")
const PORTAL = preload("res://Portal.tscn")
var boss_spawned = false
var block = false
var a = 0
var b = 0
var spawned_gk = false
var gk_move
var gk_move2 
var gk_attacked = false
var gk_timer = 0
var p_spawned = false
func _ready():
	randomize()
	random_spawnt = round(rand_range(500, 2000))
	number_of_spawns = round(rand_range(1, 3))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	scene = "grasslands.tscn"
	randomize_fog()
	Global.can_leave = false
	if Global.boss_killed == null:
		Global.boss_killed = false
	
func set_atmos():
	if $atmos.playing:
		return
	else:
		$atmos.play(0.0)

func play_theme():
	if $Maintheme.playing or is_night:
		return
	else:
		$Maintheme.play(0.0)
func night_theme():
	if $NightTheme.playing or is_day:
		return
	else:
		$NightTheme.play()

func trap(number):
	if number == 1:
		var mob = FORESTMOB.instance()
		mob.global_transform = $trapspawn.global_transform
		add_child(mob)
		mob.see_player = true
		trap = false
	if number == 2:
		var mob = FORESTMOB.instance()
		mob.global_transform = $trapspawn2.global_transform
		mob.see_player = true
		add_child(mob)

func randomize_fog():
	randomize()
	random = round(rand_range(500, 2000))
func randomize_day():
	randomize()
	day_random = round(rand_range(1000, 5000))
	day_randomized = true

func randomize_night():
	randomize()
	night_random = round(rand_range(1000, 4000))
	night_randomized = true
	
func show_bar():
	var bossbar = BOSSBAR.instance()
	if bar_shown == true:
		return
	else:
		get_child(1).add_child(bossbar)
		bar_shown = true

func randomize_num_spawns():
	if not randomized:
		number_of_spawns = round(rand_range(1, 4))
		randomized = true
func spawn_boss():
	if  Global.boss_killed == false:
		var boss = FORESTBOSS.instance()
		boss.global_transform = $Bossp.global_transform
		boss.see_player = true
		add_child_below_node(get_child(27), boss)
		boss_spawned = true
func spawn_gk():
	if spawned_gk:
		return
	if not spawned_gk:
		var knight = GOODKNIGHT.instance()
		knight.global_transform = $gkspawn.global_transform
		add_child(knight)
		spawned_gk = true

func _process(delta):
	
	if $WorldEnvironment.environment.background_energy <= 0.01:
		day_t_start = true
		night_t_start = false
		is_night = true
		is_day = false

	if $WorldEnvironment.environment.background_energy > 0.97999:
		is_day = true
		is_night = false
		day_t_start = false
		night_t_start = true

	$WorldEnvironment.environment.adjustment_enabled = true

	env_timer += 1
	fog_timer += 1
	fog_timeout += 1
	
#	if $Player.get_child(1).get_child_count() == 3:
#		$Player.is_resting = true
#	else:
#		$Player.is_resting = false

	if is_night and nspawned == false:
		for i in $Nightspawns.get_children():
			var nightmob = NIGHTMOB.instance()
			nightmob.global_transform = i.global_transform
			add_child(nightmob)
			nspawned = true
	if is_day and dspawned == false:
		for i in $Dayspawns.get_children():
			var mob = FORESTMOB.instance()
			mob.global_transform = i.global_transform
			add_child(mob)
			dspawned = true
	if is_day:
		nspawned = false
		day_timer = 0
		if not night_randomized:
			randomize_night()
		if not night_timer == night_random:
			night_timer += 1
		for i in get_children():
			if i.name.similarity("NightFMob") > 0.5:
				i.queue_free()
	if is_night:
		dspawned = false
		night_timer = 0
		if not day_randomized:
			randomize_day()
		if not day_timer == day_random:
			day_timer += 1
		for i in get_children():
			if i.name.similarity("ForestMob") > 0.59:
				i.queue_free()
				
	if $Player.is_resting and is_night:
		for i in get_children():
			if i.name.similarity("NightFMob") > 0.5:
				i.queue_free()

		
	
	if $Player.is_resting and is_day:
		for i in get_children():
			if i.name.similarity("ForestMob") > 0.59:
				i.queue_free()

	if $Player.get_child(1).get_children().has("Rest"):
		$Player.is_resting = true
	
#	
	if $Player.rested:
		if is_day:
			$Player.is_resting = false
			for i in $Dayspawns.get_children():
				var mob = FORESTMOB.instance()
				mob.global_transform = i.global_transform
				if not a == 17:
					add_child(mob)
					a += 1
				if a >= 17:
					$Player.rested = false

			
		if is_night:
			$Player.is_resting = false
			for i in $Nightspawns.get_children():
				var nightmob = NIGHTMOB.instance()
				nightmob.global_transform = i.global_transform
				if not b == 17:
					add_child(nightmob)
					b += 1
				if b >= 17:
					$Player.rested = false


	if day_timer == day_random:
		if not $Sun.light_energy > 3.05:
			$Sun.light_energy += 0.00073
		$WorldEnvironment.environment.background_energy += 0.0005
		
	if night_timer == night_random:
		if not $Sun.light_energy < 0.001:
			$Sun.light_energy -= 0.00033
		$WorldEnvironment.environment.background_energy -= 0.0001
	#Fog settings
	if fog_timer == random and not is_night:
		$WorldEnvironment.environment.fog_enabled = true
		fog_timeout = 0
	if fog_timeout > 5000 or is_night:
		$WorldEnvironment.environment.fog_enabled = false
		fog_timeout = 0
		fog_timer = 0

	#Music settings
	if $NightTheme.playing and is_night:
		if $Maintheme.playing:
			$Maintheme.stop()
	
	if $Maintheme.playing and is_day:
		if $NightTheme.playing:
			$NightTheme.stop()

	#Callbacks
	set_atmos()
	play_theme()
	night_theme()

	if trap == true:
		if spawned == false:
			trap(1)
			spawned = true
	if Global.boss_killed == false and boss_spawned:
		if boss_health < boss_base_health / 1.5:
			randomize()
			var mob = FORESTMOB.instance()
			mob.see_player = true
			for i in $Bossspawns.get_children():
				randomize()
				var p = round(rand_range(0, 4))
				mob.global_transform = $Bossspawns.get_child(p).global_transform
			if not number_of_spawns <= 0:
				add_child(mob)
			number_of_spawns -= 1
			spawn_delay += 1
		
		if spawn_delay == random_spawnt:
			randomize()
			randomize_num_spawns()
			var mob = FORESTMOB.instance()
			mob.see_player = true
			for i in $Bossspawns.get_children():
				randomize()
				var p = round(rand_range(0, 4))
				mob.global_transform = $Bossspawns.get_child(p).global_transform
			if not number_of_spawns <= 0:
				add_child(mob)
			number_of_spawns -= 1
			if number_of_spawns <= 0:
				spawn_delay = 0
				random_spawnt = round(rand_range(2000, 3500))
				
	if !block:
		$tree_block.visible = false
		$tree_block2.visible = false
		$tree_block2/StaticBody/CollisionShape.disabled = true
		$tree_block/StaticBody/CollisionShape.disabled = true
		$tree_block3.visible = false
		$tree_block3/StaticBody/CollisionShape.disabled = true
		$tree_block4.visible = false
		$tree_block4/StaticBody/CollisionShape.disabled = true
		$tree_block5.visible = false
		$tree_block5/StaticBody/CollisionShape.disabled = true
	
	if gk_move and !gk_attacked:
		print($GoodKnight.translation.z)
		if not ($GoodKnight.translation.z > -113.5 and $GoodKnight.translation.z < -112.5):
			$GoodKnight.translation.z += 0.1
			$GoodKnight.get_child(1).play("right")
		else:
			$GoodKnight.get_child(1).play("idle")
	if gk_move2 and !gk_attacked:
		gk_move = false
		if !p_spawned:
			var portal = PORTAL.instance()
			portal.global_transform = $PortalSp.global_transform
			add_child(portal)
			p_spawned = true
		if not ($GoodKnight.translation.z > -126.5 and $GoodKnight.translation.z < -125.5):
			$GoodKnight.translation.z -= 0.1
			$GoodKnight.get_child(1).play('left')
		if ($GoodKnight.translation.z > -126.5 and $GoodKnight.translation.z < -125.5):
			$GoodKnight.get_child(1).play('idle')
	if p_spawned:
		$Portal.connect("body_entered", self, "_on_Portal_body_entered")
		$Portal.connect("body_exited", self, "_on_Portal_body_exited")
	if gk_attacked:
		if !p_spawned:
			var portal = PORTAL.instance()
			portal.global_transform = $PortalSp.global_transform
			add_child(portal)
			p_spawned = true
		gk_timer += 1
		$Player.text_timer = 0
	if gk_timer == 300 and get_child(1).get_child_count() > 17:
		$Player.dialogue = false
		get_child(1).get_child(17).queue_free()
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

func _on_TrapArea_body_entered(body):
	if "Player" in body.name and !spawned2:
		trap(2)
		spawned2 = true


func _on_BossArea_body_entered(body):
	if "Player" in body.name and boss_spawned == false and Global.boss_killed == false:
		show_bar()
		Global.spawn_boss = true
		spawn_boss()
		block = true
		$tree_block.visible = true
		$tree_block2.visible = true
		$tree_block/StaticBody/CollisionShape.disabled = false
		$tree_block2/StaticBody/CollisionShape.disabled = false


func _on_Portal_body_entered(body):
	if "Player" in body.name:
		$"/root/Global".can_leave = true


func _on_Portal_body_exited(body):
	if "Player" in body.name:
		$"/root/Global".can_leave = false

func _on_Killed_body_entered(body):
	if "Player" in body.name:
		
		spawn_gk()
		var fdialogue = FDIALOGUE.instance()
		$Player.add_child(fdialogue)
		$Player.dialogue = true
		block = true
		$tree_block3.visible = true
		$tree_block3/StaticBody/CollisionShape.disabled = false
		$tree_block4.visible = true
		$tree_block4/StaticBody/CollisionShape.disabled = false
		$tree_block5.visible = true
		$tree_block5/StaticBody/CollisionShape.disabled = false
