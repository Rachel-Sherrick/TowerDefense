extends Node

@export var heal_amount: int = 25
@export var defense_boost: int = 5

func use_heal_potion(health) -> void:
	if health == null:
		return
	
	health.heal(heal_amount)
	print("Healing potion used")


func use_defense_potion(health) -> void:
	if health == null:
		return
	
	health.defense += defense_boost
	print("Defense potion used")
