extends Node
# Reusable Health Component
# Adds health behavior to any Node parent.

signal health_changed(current_health: int, max_health: int)
signal died

@export var max_health: int = 100
@export var defense: int = 0
@export var destroy_parent_on_death: bool = true

var current_health: int


func _ready() -> void:
	var parent = get_parent()

	if parent != null and (parent.name == "Tower" or parent.name == "Tower2"):
		max_health = 50

	current_health = max_health
	print(get_parent().name, "spawned with health:", current_health)

	if parent != null:
		var bar = parent.get_node_or_null("HealthBar/MeshInstance3D")
		if bar != null and bar.mesh != null:
			bar.mesh = bar.mesh.duplicate()
			bar.scale.x = 1.0

	emit_signal("health_changed", current_health, max_health)
	_update_bar()


# Sets health directly. Returns false if entity died.
func set_current_health(new_health: int) -> bool:
	current_health = clamp(new_health, 0, max_health)

	emit_signal("health_changed", current_health, max_health)
	_update_bar()

	if current_health == 0:
		_handle_death()
		return false

	return true


func take_damage(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return

	var final_damage = amount - defense
	if final_damage <= 0:
		final_damage = 1

	current_health -= final_damage
	current_health = clamp(current_health, 0, max_health)

	print(get_parent().name, "took damage. Current health:", current_health)

	emit_signal("health_changed", current_health, max_health)
	_update_bar()

	if current_health == 0:
		_handle_death()


func heal(amount: int) -> void:
	if amount <= 0 or current_health <= 0:
		return

	current_health += amount
	current_health = clamp(current_health, 0, max_health)

	emit_signal("health_changed", current_health, max_health)
	_update_bar()


func _update_bar() -> void:
	var parent = get_parent()
	if parent == null:
		return

	var bar = parent.get_node_or_null("HealthBar/MeshInstance3D")
	if bar == null:
		return

	var percent := float(current_health) / float(max_health)
	bar.scale.x = percent


func _handle_death() -> void:
	var parent = get_parent()
	var tree = get_tree()

	if parent != null and (parent.name == "Tower" or parent.name == "Tower2"):
		if tree != null:
			tree.call_deferred("change_scene_to_file", "res://EndOfGameLose.tscn")
		return

	emit_signal("died")

	if destroy_parent_on_death and parent:
		parent.queue_free()
