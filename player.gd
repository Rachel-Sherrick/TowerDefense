class_name Player
extends Node

signal tower_placed(tower: Tower)
@export var warrior_scene: PackedScene
@export var wizard_scene: PackedScene

##the amount of money the player has
@export var money: float
##the rate of intrest earned for clearing a wave
@export var interest: float
##the UI label that shows amount of money
@onready var coins_label: Label = $GUI/CoinsLabel

@onready var warrior_count: Label = $GUI/InventoryBar/WarriorBox/WarriorCount
var warrior_num: int = 0
@onready var wizard_count: Label = $GUI/InventoryBar/WizardBox/WizardCount
var wizard_num: int = 0

@onready var warrior_box: ColorRect = $GUI/InventoryBar/WarriorBox
@onready var wizard_box: ColorRect = $GUI/InventoryBar/WizardBox

##the selected inventory item
@export_enum("warrior", "wizard") var selected_item: String

##the inventory of potions and bought player towers
var inventory_dict: Dictionary[String, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_label.text = ("Coins: " + str(money))
	warrior_count.text = (str(warrior_num))
	wizard_count.text = (str(wizard_num))

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
			
		## updates the inventory gui
		inventory_dict[selected_item] -= 1
		
		##updates the text
		update_inventory_text()
		
		## spawns the selected tower
		if selected_item == "warrior":
			var tower: Tower = warrior_scene.instantiate()
			get_parent().get_node("Battleground").get_node("Characters").add_child(tower)
			tower.global_position = Vector3(event_position.x, 0, event_position.z)
			print(tower.name + " spawned at ", event_position)
			emit_signal("tower_placed", tower)
			warrior_box.color = Color("fed863")
			
		if selected_item == "wizard":
			var tower: Tower = wizard_scene.instantiate()
			get_parent().get_node("Battleground").get_node("Characters").add_child(tower)
			tower.global_position = Vector3(event_position.x, 0, event_position.z)
			print(tower.name + " spawned at ", event_position)
			emit_signal("tower_placed", tower)
			wizard_box.color = Color("fed863")
			
		#var tower: Tower = tower_scene.instantiate()
		#get_parent().get_node("Battleground").get_node("Characters").add_child(tower)
		#tower.global_position = Vector3(event_position.x, 0, event_position.z)
		#print(tower.name + " spawned at ", event_position)
		#emit_signal("tower_placed", tower)

func _on_shop_purchase(item_name: String, cost: float) -> void:
	if money - cost < 0:
		print(name, " went out of money")
		return
	_alter_money(-cost)
	if (inventory_dict.get(item_name) == null):
		inventory_dict[item_name] = 1
		inventory_purchase_update(item_name)
	else:
		inventory_dict[item_name] += 1
		inventory_purchase_update(item_name)
	print(item_name, " bought")
	print(inventory_dict)
	
func update_inventory_text() -> void:
	if (inventory_dict.get("warrior") != null):
		warrior_count.text = (str(inventory_dict["warrior"]))
	if (inventory_dict.get("wizard") != null):
		wizard_count.text = (str(inventory_dict["wizard"]))

func inventory_purchase_update(tower_purchase) -> void:
	if tower_purchase == "warrior":
		warrior_num = inventory_dict[tower_purchase]
		warrior_count.text = (str(warrior_num))
	elif tower_purchase == "wizard":
		wizard_num = inventory_dict[tower_purchase]
		wizard_count.text = (str(wizard_num))

func _on_warrior_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")) && selected_item == "wizard":
		#print("CLICKED")
		warrior_box.color = Color("fff1ca")
		wizard_box.color = Color("fed863")
		selected_item = "warrior"
	elif (event.is_action_pressed("click")):
		#print("CLICKED")
		warrior_box.color = Color("fff1ca")
		selected_item = "warrior"

func _on_wizard_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")) && selected_item == "warrior":
		wizard_box.color = Color("fff1ca")
		warrior_box.color = Color("fed863")
		selected_item = "wizard"
	elif (event.is_action_pressed("click")):
		wizard_box.color = Color("fff1ca")
		selected_item = "wizard"
