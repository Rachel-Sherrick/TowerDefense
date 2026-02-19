extends Node
# This script adds health behavior to a Node.


signal health_changed(current_health: int, max_health: int)
# Emitted whenever health changes.
# Sends current and max health.


signal died
# Emitted when health reaches 0.


@export var max_health: int = 100
# Maximum possible health (editable in Inspector).


var current_health: int
# Stores current health value.


func _ready() -> void:
	current_health = max_health
	# Start fully healed.

	emit_signal("health_changed", current_health, max_health)
	# Notify others that health is initialized.


func take_damage(amount: int) -> void:
	if current_health <= 0:
		return  # already dead, ignore

	current_health -= amount
	# Subtract damage.

	current_health = max(current_health, 0)
	# Prevent health going below 0.

	emit_signal("health_changed", current_health, max_health)
	# Notify listeners of change.

	if current_health == 0:
		_handle_death()
		# If health hits 0, handle death.


func heal(amount: int) -> void:
	if current_health <= 0:
		return  # cannot heal if dead

	current_health += amount
	# Add healing.

	current_health = min(current_health, max_health)
	# Prevent exceeding max health.

	emit_signal("health_changed", current_health, max_health)
	# Notify listeners of change.


func _handle_death() -> void:
	emit_signal("died")
	# Tell other systems this entity died.

	print("Health reached zero — entity died")
	# Debug message.

	# remove the entity that owns this health
	if get_parent():
		get_parent().queue_free()
		# Remove the parent node from the scene.
