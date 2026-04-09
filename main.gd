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
@onready var shop_cam: Camera3D = $Shop/ShopBody/ShopCamera/Camera3D
@onready var battle_cam: Camera3D = $Battleground/BattleCamera/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_view"):
		if battle_cam.current:
			shop_cam.make_current()
		elif shop_cam.current:
			battle_cam.make_current()
		print("Camera swapped")
