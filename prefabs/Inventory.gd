extends Node3D

#var items
@export var money: int = 0: set = add_subtract_money, get = get_money
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_subtract_money(add_amount: int):
	money += add_amount
	if money > 9999:
		money = 9999 # NOTE: this is probably inefficient

func get_money():
	return money
