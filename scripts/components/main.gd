extends Node

@onready var battle_cam: Camera3D = $Battleground/BattleCamera/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
###H.S NEEDS THIS TO STAY HERE
func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://EndOfGameLose.tscn")
