extends Node

##the amount of money the player has
@export var cash: float = 0
##the rate of intrest earned for clearing a wave
@export var interest: float = 1.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_battleground_child_entered_tree(node: Node) -> void:
	if node.is_in_group("Enemy"):
		node.connect("died", _earn_money)

func _earn_money(value: float):
	cash += value

## needs to be linked with a signal on a wave clear
func _on_wave_cleared() -> void:
	cash *= interest
