extends Node

@onready var death_screen = $DeathScreen/PanelRoot
@onready var label = $DeathScreen/PanelRoot/VBoxContainer/Label

func _ready():
	death_screen.visible = false

	# --- PLAYER ---
	var player = $Character5
	var player_health = player.get_node_or_null("Health")

	if player_health != null:
		player_health.died.connect(_on_player_died)
	else:
		print("Player has NO Health node")

	# --- ENEMIES ---
	for enemy in get_tree().get_nodes_in_group("Enemy"):

		# Skip helper nodes like RangeDetection
		if enemy.name == "RangeDetection":
			continue

		var e_health = enemy.get_node_or_null("Health")

		if e_health != null:
			e_health.died.connect(_on_enemy_died)
		else:
			print("No Health child on enemy:", enemy.name)


# --------------------------
# PLAYER DEATH
# --------------------------
func _on_player_died():
	print("PLAYER DIED -> GAME OVER")
	show_game_over()


# --------------------------
# ENEMY DEATH
# --------------------------
func _on_enemy_died():
	await get_tree().process_frame

	var enemies_left = []

	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.name != "RangeDetection":
			enemies_left.append(enemy)

	if enemies_left.is_empty():
		print("ALL ENEMIES DEAD -> WIN")
		show_win()


# --------------------------
# UI
# --------------------------
func show_game_over():
	death_screen.visible = true
	label.text = "YOU WERE DESTROYED D: !!!!!"


func show_win():
	death_screen.visible = true
	label.text = "YOU HAVE SURVIVED :D !!!!!"
