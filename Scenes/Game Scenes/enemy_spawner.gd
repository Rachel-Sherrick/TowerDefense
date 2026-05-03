extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_point: Node3D
@export var spawn_interval: float = 4.0   # longer delay after first
@export var max_enemies: int = 10
@onready var final_target = get_tree().current_scene.get_node("Battleground/Orb")
var spawn_interval_done: bool = false
var round_started: bool = false

@onready var start_round_button: Button = $"../Player/GUI/StartRoundButton"
var wave = 1
var round = 1
@onready var wave_label: Label = $Player/GUI/WaveLabel
@onready var round_label: Label = $Player/GUI/RoundLabel
@onready var health: Health = $Health
var enemies_killed = 0


var _timer: float = 0.0
var _count: int = 0

func _ready() -> void:
	print("Spawner ready")
	$SpawnTimer.wait_time = spawn_interval
	#$Battleground/Orb/Health.enemy_killed.connect(_on_enemy_killed)

func _process(delta: float) -> void:
	if enemies_killed >= 10 and !$Battleground/Orb.orb_destroyed:
		if wave < 5:
			wave += 1
			wave_label.text = ("Wave: " + str(wave))
		else: 
			wave = 1
			round += 1
			round_label.text = ("Round: " + str(round))
			start_round_button.show()
			round_started = false

func spawn_enemy() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.final_target = final_target
	var parent = get_tree().current_scene.get_node("Battleground/Characters")
	parent.add_child(enemy)
	spawn_point.position.z = randi_range(-12, 12)
	enemy.global_position = spawn_point.global_position

	print("Spawned at:", enemy.global_position)
	_count += 1


func _on_spawn_timer_timeout() -> void:
	spawn_interval_done = true
	if enemy_scene == null or spawn_point == null:
		print("Spawn point null")
		return
	if _count >= max_enemies:
		print("Count too big")
		return
	if round_started == true:
		spawn_enemy()


func _on_start_round_button_pressed() -> void:
	if spawn_interval_done == true:
		if enemy_scene == null or spawn_point == null:
			print("Spawn point null")
			return
		if _count >= max_enemies:
			print("Count too big")
			return
		spawn_enemy()
	round_started = true
	start_round_button.hide()
	
func _on_enemy_killed():
	enemies_killed += 1
