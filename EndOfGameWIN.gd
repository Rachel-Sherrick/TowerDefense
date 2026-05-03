extends Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Game Scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
