extends Node

@onready var how_to_play_screen: CanvasLayer = $"../HowToPlayScreen"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game Scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_how_to_play_button_pressed() -> void:
	how_to_play_screen.show()


func _on_back_button_pressed() -> void:
	how_to_play_screen.hide()
