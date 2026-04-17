extends Node

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

###H.S NEEDS THIS TO STAY HERE
func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://EndOfGameLose.tscn")
