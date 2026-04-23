extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_point: Node3D
@export var spawn_interval: float = 4.0   # longer delay after first
@export var max_enemies: int = 10

var _timer: float = 0.0
var _count: int = 0

func _ready() -> void:
	print("Spawner ready")
	spawn_enemy()  # 👈 spawn immediately

func _process(delta: float) -> void:
	if enemy_scene == null or spawn_point == null:
		return

	if _count >= max_enemies:
		return

	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		spawn_enemy()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var parent = get_tree().current_scene.get_node("Battleground/Characters")
	parent.add_child(enemy)
	enemy.global_position = spawn_point.global_position

	print("Spawned at:", enemy.global_position)
	_count += 1
