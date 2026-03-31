class_name Player
extends Node

##the amount of money the player has
@export var money: float
##the rate of intrest earned for clearing a wave
@export var interest: float

##the inventory of potions and bought player towers
var inventory_dict: Dictionary[String, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_battleground_child_entered_tree(node) -> void:
	if node is Enemy:
		node.connect("died", _alter_money)

func _alter_money(value: float):
	money += value

## needs to be linked with a signal on a wave clear
func _on_wave_cleared() -> void:
	money *= interest

# Decreases money when tower placed; temp function
func _on_placeable_area_tower_placed(tower: Tower) -> bool:
	if (money > 0):
		_alter_money(-1)
		return true
	tower.queue_free()
	return false

func _on_shop_purchase(item_name: String, cost: float) -> void:
	if money - cost < 0:
		print(name, " went out of money")
		return
	_alter_money(-cost)
	inventory_dict[name] = 1
	print(item_name, " bought")
