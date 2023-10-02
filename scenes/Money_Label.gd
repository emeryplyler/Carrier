extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
#	var inventory = get_node("/root/Main/Player/Inventory")
#	inventory.connect("money_changed", self, "change_text")
#	inventory.connect("money_changed", change_text)
#	inventory.money_changed.connect(_change_text)
#	inventory.connect("money_changed", change_text)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _change_text(new_amount: int):
#	print("signal recieved")
#	text = str(new_amount)


func _on_player_money_changed(amount):
	text = str(amount)
