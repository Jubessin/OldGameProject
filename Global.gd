extends Node

var previous_scene
var player_health = 1000
var player_rammo = 0
var player_pammo = 0
var player_sammo = 0
var player_spare_rammo = 84
var player_spare_pammo = 48
var player_spare_sammo = 22
var player_eqp_wep
var player_unfound_weps = ["Smg", "Shotgun"]
var player_alt_weps = ["Rifle", "Laser"]
var reset_health = 1000
var reset_rsp_ammo = 84
var reset_psp_ammo = 48
var reset_spp_ammo = 22
var spare_hpots = 0
var spare_spots = 0
var spare_stpots = 0
var spare_grenades = 0
var is_crouched = false
var hpot_used = false
var sta_pot_used = false
var str_pot_used = false
var player_in_battle = false
var player_cur_pos
var current_scene = ""
var can_rest
var can_leave
var enemy_cur_pos = []
var in_cutscene = false
var cutscene
var spawn_boss = false
var save_data = {}
var player_data
var boss_killed
var next_map = ""
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss_killed:
		spawn_boss = false