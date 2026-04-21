class_name Player
extends Node

signal tower_placed(tower: Tower)
@export var tower_scene: PackedScene

##the amount of money the player has
@export var money: float
##the rate of intrest earned for clearing a wave
@export var interest: float
##the UI label that shows amount of money
@onready var coins_label: Label = $GUI/CoinsLabel

##the selected inventory item
@export_enum("warrior", "buff_potion", "damage_potion") var selected_item: String

##the inventory of potions and bought player towers
var inventory_dict: Dictionary[String, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_label.text = ("Coins: " + str(money))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_battleground_child_entered_tree(node) -> void:
	if node is Enemy:
		#eventually create variables for different amount of
		#money earned after killing different enemies?
		node.connect("died", _alter_money(1.0))

func _alter_money(value: float):
	money += value
	coins_label.text = ("Coins: " + str(money))

## needs to be linked with a signal on a wave clear
func _on_wave_cleared() -> void:
	money *= interest
	coins_label.text = ("Coins: " + str(money))

func _place_tower(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("right_click"):
		if (
			inventory_dict.get(selected_item) == null
			or inventory_dict.get(selected_item) < 1
		):
			print("No bought ", selected_item)
			return
		inventory_dict[selected_item] -= 1
		var tower: Tower = tower_scene.instantiate()
		get_parent().get_node("Battleground").get_node("Characters").add_child(tower)
		tower.global_position = Vector3(event_position.x, 0, event_position.z)
		print(tower.name + " spawned at ", event_position)
		emit_signal("tower_placed", tower)

func _on_shop_purchase(item_name: String, cost: float) -> void:
	if money - cost < 0:
		print(name, " went out of money")
		return
	_alter_money(-cost)
	if (inventory_dict.get(selected_item) == null):
		inventory_dict[item_name] = 1
	else:
		inventory_dict[item_name] += 1
	print(item_name, " bought")
	print(inventory_dict)
