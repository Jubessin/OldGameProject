extends Node
const SAVE_PATH = "user://game_save"
var save_slot = 0
var timer = 0
var timer_start = false
var player_updated = false
var right_scene = false
var player_translation
var player_in_pos = false
var player_data
var loaded = false
func save_game():
	var save_dict = {}
	var nodes_to_save = get_tree().get_nodes_in_group('persistent')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()
	
	var save_file = File.new()
	if  save_file.file_exists(SAVE_PATH+String(save_slot)+".txt"):
		save_file.open(SAVE_PATH+String(save_slot)+".txt", File.WRITE)
		save_file.store_line(to_json(save_dict))

		save_file.close()
	else:
		print("Overwrite saved data?")
func new_game():
	var save_dict = {
		"health" : 1000,
		"p_spare_ammo" : 48,
		"r_spare_ammo" : 81,
		"eqp" : 1,
		"unfound_weapons" : ["Pistol", "Rifle", "Smg", "Launcher", "Shotgun"],
		"spare_hpots" : 0,
		"spare_spots" : 0,
		"spare_stpots" : 0,
		"grenades" : 0,
	}
	Global.player_unfound_weps = ["Pistol", "Rifle", "Smg", "Laserr", "Shotgun"]
	var nodes_to_save = get_tree().get_nodes_in_group('persistent')
	for node in nodes_to_save:
		save_dict[node.get_path()] = node.save()

	var save_file = File.new()
	save_file.open(SAVE_PATH +String(save_slot)+".txt", File.WRITE)
	save_file.store_line(to_json(save_dict))
	save_file.close()
#	get_tree().change_scene("prologue.tscn")
	get_tree().change_scene("Castle.tscn")
	
func load_game():
	var current_scene = get_tree().current_scene
	var save_file = File.new()
	if not save_file.file_exists(SAVE_PATH+String(save_slot)+".txt"):
		print("File does not exist")
		return

	save_file.open(SAVE_PATH+String(save_slot)+".txt", File.READ)
	var data = {}
	data = JSON.parse(save_file.get_as_text()).result


	for node_path in data.keys():
		var node = get_node(node_path)

		for attribute in data[node_path]:
			if attribute == "parent":
				if get_tree().current_scene.filename == "res://Titlescreen.tscn" or get_tree().current_scene.filename == "res://deathscene.tscn":
					get_tree().change_scene(data[node_path]['parent'])
				else:
					continue
			if attribute == "pos":
				player_translation = (Vector3(data[node_path]['pos']['x'], data[node_path]['pos']['y'], data[node_path]['pos']['z']))
			if attribute == "unfound_weapons":
				Global.player_unfound_weps = data[node_path]['unfound_weapons']
			if attribute == "alternate_weapons":
				Global.player_alt_weps = data[node_path]['alternate_weapons']
			else:
				Global.player_eqp_wep = data[node_path]['eqp']
				Global.player_health = data[node_path]['health']
				Global.player_spare_pammo = data[node_path]['p_spare_ammo']
				Global.player_spare_rammo = data[node_path]['r_spare_ammo']
#				Global.player_unfound_weps = data[node_path]['unfound_weapons']
				Global.spare_grenades = data[node_path]['spare_grenades']
				Global.spare_hpots = data[node_path]['spare_hpots']
				Global.spare_spots = data[node_path]['spare_spots']
				Global.spare_stpots = data[node_path]['spare_stpots']
				Global.boss_killed = data[node_path]['boss_killed']
				settings.mouse_sensitivity = data[node_path]['mouse_sensitivity'] * 10
				settings.difficulty = data[node_path]['difficulty']
	save_file.close()
	set_attr(player_translation) 
	loaded = true
func set_attr(pos):
	if get_tree().current_scene.filename == "res://cavemap.tscn":
		var player = get_tree().current_scene.get_child(1)
		if !pos == null:
			player.global_transform.origin = pos
			if player.global_transform.origin == pos:
				player_in_pos = true
				return player and player_in_pos
	if get_tree().current_scene.filename == "res://grasslands.tscn":
		var player = get_tree().current_scene.get_child(1)
		if !pos == null:
			player.global_transform.origin = pos
			if player.global_transform.origin == pos:
				player_in_pos = true
				return player and player_in_pos

var current_save_game # This is the contents of the save file, for now we just declare it
var default_save = {"money":0,"powers":null} # The default save contents, if there is no save file to load, then, the current_save_game gets its contents from this variable and then creates a save file with it

#func _ready():
#	current_save_game = load_game(save_slot) if typeof(load_game(save_slot)) == TYPE_DICTIONARY else default_save # This is the first loading, when the game starts.
#
#func load_game(save_slot): # I used the concept of save slots to handle multiple saves, use what suits you.
#	var F = File.new() # We initialize the File class
#	var D = Directory.new() # and the Directory class
#	if D.dir_exists("user://save"): # Check if the folder 'save' exists before moving on
#		if F.open(str("user://save/",save_slot,".save"), File.READ_WRITE) == OK: # If the opening of the save file returns OK
#			var temp_d # we create a temporary var to hold the contents of the save file
#			temp_d = F.get_var() # we get the contents of the save file and store it on TEMP_D
#			return temp_d # we return it to do our thing
#		else: # In case the opening of the save file doesn't give an OK, we create a save file
#			print("save file doesn't exist, creating one") 
#			save_game(save_slot) 
#	else: # If the folder doesn't exist, we create one...
#		D.make_dir("user://save")
#		save_game(save_slot) # and we create the save file using the save_game function
#
#func save_game(save_slot): # This functions save the contents of current_save_game variable into a file 
#	var F = File.new()
#	F.open(str("user://save/",save_slot,".save"), File.READ_WRITE) # we open the file
#	F.store_var(current_save_game) # then we store the contents of the var save inside it
#	F.close() # and we gracefully close the file :)
	
func _process(delta):
	if get_tree().current_scene.filename == "res://cavemap.tscn" or get_tree().current_scene.filename == "res://grasslands.tscn" and player_in_pos == false and loaded:
		set_attr(player_translation)
		loaded = false
	