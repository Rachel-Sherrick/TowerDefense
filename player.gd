class_name Player
extends Node

##the amount of money the player has
@export var cash: float
##the rate of intrest earned for clearing a wave
@export var interest: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_battleground_child_entered_tree(node) -> void:
	if node.is_in_group("Enemy"):
		node.connect("died", _alter_money)

func _alter_money(value: float):
	cash += value

## needs to be linked with a signal on a wave clear
func _on_wave_cleared() -> void:
	cash *= interest
