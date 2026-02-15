extends Node

signal health_changed(current_health: int, max_health: int)
signal died

@export var max_health: int = 100
var current_health: int


func _ready() -> void:
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)


func take_damage(amount: int) -> void:
	if current_health <= 0:
		return  # already dead, ignore

	current_health -= amount
	current_health = max(current_health, 0)

	emit_signal("health_changed", current_health, max_health)

	if current_health == 0:
		_handle_death()


func heal(amount: int) -> void:
	if current_health <= 0:
		return  # cannot heal if dead

	current_health += amount
	current_health = min(current_health, max_health)

	emit_signal("health_changed", current_health, max_health)


func _handle_death() -> void:
	emit_signal("died")
	print("Health reached zero — entity died")

	# remove the entity that owns this health
	if get_parent():
		get_parent().queue_free()
