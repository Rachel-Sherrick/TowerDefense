extends Node

@export var enemy_scene: PackedScene
@export var spawn_delay := 1.5

var timer := 0.0

func _process(delta):
	timer += delta
	
	if timer >= spawn_delay:
		spawn_enemy()
		timer = 0.0

func spawn_enemy():
	var path_follow = PathFollow3D.new()
	path_follow.set_script(preload("res://scripts/components/enemypath.gd"))
	path_follow.progress = 0
	path_follow.rotation_degrees = Vector3(0,0,0)
	
	var enemy = enemy_scene.instantiate()
	enemy.rotation_degrees = Vector3(0,0,0)
	
	path_follow.add_child(enemy)
	
	get_node("../EnemyPath").add_child(path_follow)
