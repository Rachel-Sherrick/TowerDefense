extends Node

@onready var pause_canvas: CanvasLayer = $"../PauseCanvas"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_pause_button_pressed() -> void:
	pause_canvas.show()
	get_tree().paused = true
	print("GAME PAUSED")


func _on_play_button_pressed() -> void:
	pause_canvas.hide()
	get_tree().paused = false
	print("GAME RESUMED")
