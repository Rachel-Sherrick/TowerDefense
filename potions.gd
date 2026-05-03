extends Node

@export var heal_amount: int = 10
@export var damage_amount: int = 10

static var action_lock: bool = false

func _ready() -> void:
	print("Potions2 active on ", get_parent().name)
	set_process_unhandled_input(get_parent() != null and get_parent().name == "Tower")

func _unhandled_input(event: InputEvent) -> void:
	if action_lock:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_H:
			print("H detected in potions.gd")
			action_lock = true
			use_heal_potion()
			await get_tree().create_timer(0.25).timeout
			action_lock = false
			return

		if event.keycode == KEY_D:
			print("D detected in potions.gd")
			action_lock = true
			use_damage_potion()
			await get_tree().create_timer(0.25).timeout
			action_lock = false
			return

func use_heal_potion() -> void:
	print("use_heal_potion() CALLED")

	var scene = get_tree().current_scene
	if scene == null:
		print("Potion Health failed | No current scene")
		return

	var tower = scene.get_node_or_null("Tower")
	var tower2 = scene.get_node_or_null("Tower2")

	if tower != null and tower.has_method("heal"):
		tower.heal(heal_amount)
		print("Potion Health used +10 | Tower healed")

	if tower2 != null and tower2.has_method("heal"):
		tower2.heal(heal_amount)
		print("Potion Health used +10 | Tower2 healed")

func use_damage_potion() -> void:
	print("use_damage_potion() CALLED")

	var scene = get_tree().current_scene
	if scene == null:
		print("Potion Damage failed | No current scene")
		return

	var hit_any_enemy := false

	for child in scene.get_children():
		if child is Enemy:
			child.take_damage(damage_amount)
			print("Potion Damage used +10 | Hit ", child.name)
			hit_any_enemy = true

	if not hit_any_enemy:
		print("Potion Damage used +10 | No enemies found")
