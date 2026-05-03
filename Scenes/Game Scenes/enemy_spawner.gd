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
@onready var wave_label: Label = $"../Player/GUI/WaveLabel"
@onready var round_label: Label = $"../Player/GUI/RoundLabel"
var enemies_killed = 0
var _timer: float = 0.0
var _count: int = 0
var orb_dead: bool = false

signal round_completed()

func _ready() -> void:
	print("Spawner ready")
	$SpawnTimer.wait_time = spawn_interval
	$"../Battleground/Characters".child_exiting_tree.connect(_character_killed)
	$"../Battleground/Orb".orb_destroyed.connect(_on_player_died)

func _process(delta: float) -> void:
	pass

func advance_wave():
	if enemies_killed >= 10 and !(orb_dead):
		if wave < 5 and round >= 3:
			wave += 1
			round = 1
			wave_label.text = ("Wave: " + str(wave))
		else:
			round += 1
			if round > 1:
				start_round_button.text = "- Finish -"
			round_label.text = ("Round: " + str(round))
			start_round_button.show()
			round_started = false

func spawn_enemy() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.final_target = final_target
	var parent = get_tree().current_scene.get_node("Battleground").get_node("Characters")
	spawn_point.position.z = randi_range(-12, 12)
	enemy.position.x = -30
	parent.add_child(enemy)
	enemy.position = spawn_point.global_position

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
			if round > 1:
				print("Round complete")
				emit_signal("round_completed")
			return
		spawn_enemy()
	round_started = true
	start_round_button.hide()
	
func _character_killed(character):
	if character is Enemy:
		enemies_killed += 1
	advance_wave()	
		
func _on_player_died():
	orb_dead = true
