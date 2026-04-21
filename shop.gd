extends CanvasLayer

signal purchase(name: String, cost: float)

@onready var player: Player = $"../.."

@onready var warrior_count: Label = $"../InventoryBar/WarriorBox/WarriorCount"
var warrior_num: int = 0
@onready var wizard_count: Label = $"../InventoryBar/WizardBox/WizardCount"
var wizard_num: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_slot_1_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "warrior", 1)
		if player.money >= 1:
			warrior_num +=1
			warrior_count.text = (str(warrior_num))

func _on_slot_2_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "wizard", 1)
		if player.money >= 1:
			wizard_num += 1
			wizard_count.text = (str(warrior_num))

func _on_slot_3_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "health_potion", 1)

func _on_slot_4_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "range_potion", 1)
		#increases tower range

func _on_slot_5_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "damage_potion", 1)
		#increases tower damage points per hit

func _on_slot_6_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "speed_potion", 1)
		#increases tower rate of fire / lowers cooldown
