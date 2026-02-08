extends Node

@export var max_health = 100
var current_health

func _ready():
	current_health = max_health

func take_damage(amount):
	current_health -= amount
	print("Health:", current_health)

	if current_health <= 0:
		print("I am dead")
