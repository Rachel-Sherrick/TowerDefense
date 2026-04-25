extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_point: Node3D
@export var spawn_interval: float = 4.0   # longer delay after first
@export var max_enemies: int = 10

var _timer: float = 0.0
var _count: int = 0

func _ready() -> void:
	print("Spawner ready")
	$SpawnTimer.wait_time = spawn_interval
	spawn_enemy()  # 👈 spawn immediately

func _process(delta: float) -> void:
	pass

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var parent = get_tree().current_scene.get_node("Battleground/Characters")
	parent.add_child(enemy)
	spawn_point.position.z = randi_range(-12, 12)
	enemy.global_position = spawn_point.global_position

	print("Spawned at:", enemy.global_position)
	_count += 1


func _on_spawn_timer_timeout() -> void:
	if enemy_scene == null or spawn_point == null:
		print("Spawn point null")
		return
	if _count >= max_enemies:
		print("Count too big")
		return
	spawn_enemy()
