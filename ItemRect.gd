extends TextureRect
var hide = false
var text_timer = 0
func _ready():
	update_inventory()

func update_desc():
	get_parent().get_child(9).show()
	if $".".name == "BLButton" and $"."/BLButton.is_hovered():
		get_parent().get_child(9).clear()
		get_parent().get_child(9).add_text("INFO: Pistol Ammunition. Lethal.")
		
	if $".".name == "BLButton2" and $"."/BLButton.is_hovered():
		get_parent().get_child(9).clear()
		get_parent().get_child(9).add_text("INFO: Rifle Ammunition. Lethal")
	
	if $".".name == "BRButton" and $"."/BLButton.is_hovered():
		get_parent().get_child(9).clear()
		get_parent().get_child(9).add_text("INFO: Grenades. Deal significant damage. Beware explosion.")
	hide = true
	
func update_inventory():
	$RichTextLabel.clear()
	if $".".name == "BLButton":
		$"."/Pammo.show()
		if $"/root/Global".player_spare_pammo >= 0:
			$"."/RichTextLabel.add_text("P. Ammo		" + String($"/root/Global".player_spare_pammo))
	
	if $".".name == "BLButton2":
		$"."/Rammo.show()
		if $"/root/Global".player_spare_rammo >= 0:
			$"."/RichTextLabel.add_text("R. Ammo		 " + String($"/root/Global".player_spare_rammo))

	if $".".name == "BRButton":
		$"."/grenades.show()
		if $"/root/Global".spare_grenades >= 0:
			$"."/RichTextLabel.add_text("F. Grenades		" + String($"/root/Global".spare_grenades))
func _physics_process(delta):
	update_desc()
	if hide == true:
		text_timer += 1
	if text_timer == 100:
		get_parent().get_child(9).clear()
		hide = false
		text_timer = 0
