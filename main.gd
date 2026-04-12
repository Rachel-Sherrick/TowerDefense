extends Node

const ENEMY_SCENE = preload ("res://Scenes/enemies/ant.tscn")

@onready var shop_cam: Camera3D = $Shop/ShopBody/ShopCamera/Camera3D
@onready var battle_cam: Camera3D = $Battleground/BattleCamera/Camera3D
@onready var characters = $Battleground/Characters

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemy()

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

# Spawns enemies on left side of map
func spawn_enemy() -> void:
	var enemy = ENEMY_SCENE.instantiate()
	characters.add_child(enemy)
	enemy.global_position = Vector3(-20, 0, 0)
	print("spawned enemy:", enemy)
