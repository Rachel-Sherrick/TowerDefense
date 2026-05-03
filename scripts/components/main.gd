extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Battleground/Orb.orb_destroyed.connect(_on_player_died)
	$EnemySpawner.round_completed.connect(_on_round_completed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

###H.S NEEDS THIS TO STAY HERE
func _on_player_died() -> void:
	for child in $Battleground/Characters.get_children():
		child.queue_free()
	
	get_tree().change_scene_to_file("res://EndOfGameLOSE.tscn")
	
func _on_round_completed() -> void:
	for child in $Battleground/Characters.get_children():
		child.queue_free()
	
	get_tree().change_scene_to_file("res://EndOfGameWIN.tscn")
