extends TextureRect
var dialogue_timer = 0
var di_timer2 = 0
var dialogue1 = load("res://castleassets/dialogue1.png")
var dialogue2 = load("res://castleassets/dialogue2.png")
var dialogue3 = load("res://castleassets/dialogue3.png")
var dialogue4 = load("res://castleassets/dialogue4.png")
var dialogue5 = load("res://castleassets/dialogue5.png")
var dialogue7 = load("res://castleassets/dialogue7.png")
var dialogue6 = load("res://castleassets/dialogue6.png")
var dialogue8 = load("res://castleassets/dialogue8.png")
var dialogue9 = load("res://castleassets/dialogue9.png")
var dialogue10 = load("res://castleassets/dialogue10.png")
var dialogue11 = load("res://castleassets/dialogue11.png")

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dialogue_timer += 1
	if dialogue_timer == 10:
		get_parent().get_child(1).visible = true
	print(dialogue_timer)
	if dialogue_timer == 1220:
		get_parent().get_child(1).queue_free()
	if dialogue_timer == 1000:
		$".".texture = dialogue1
	if dialogue_timer == 1100:
		$".".texture = null
	if dialogue_timer == 1340:
		$".".texture = dialogue2
	if dialogue_timer == 1440:
		$".".texture = null
	if dialogue_timer == 1500:
		$".".texture = dialogue3
	if dialogue_timer == 1600:
		$".".texture = null
	if get_parent().get_parent().get_parent().get_parent().cutscene == "Throneroom":
		di_timer2 += 1
	if di_timer2 == 100:
		$".".texture = dialogue4
	if di_timer2 == 200:
		$".".texture = null
	if di_timer2 == 350:
		$".".texture = dialogue5
	if di_timer2 == 500:
		$".".texture = null
	if di_timer2 == 600:
		$".".texture = dialogue6 
	if di_timer2 == 700:
		$".".texture = null
	if di_timer2 == 800:
		$".".texture = dialogue7
	if di_timer2 == 900:
		$".".texture = null
	if di_timer2 == 1000:
		$".".texture = dialogue8
	if di_timer2 == 1100:
		$".".texture = null
	if di_timer2 == 1300:
		$".".texture = dialogue9
	if di_timer2 == 1380:
		$".".texture = null
	if di_timer2 == 1600:
		$".".texture = dialogue10
	if di_timer2 == 1900:
		$".".texture = null
	if di_timer2 == 2100:
		get_parent().get_parent().get_parent().get_parent().get_parent().kingready = true
	if di_timer2 == 2300:
		$".".texture = dialogue11