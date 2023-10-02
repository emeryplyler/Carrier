extends Node3D

#var items
@export var money: int = 0: set = add_subtract_money, get = get_money
signal money_changed(amount: int) # to change UI money text
# Called when the node enters the scene tree for the first time.
func _ready():
	money_changed.emit(money)

func add_subtract_money(add_amount: int):
	money += add_amount
	if money > 9999:
		money = 9999 # NOTE: this is probably inefficient
	money_changed.emit(money)

func get_money():
	return money
