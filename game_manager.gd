extends Node

@onready var pause_canvas: CanvasLayer = $"../PauseCanvas"
@onready var shop_canvas: CanvasLayer = $"../ShopCanvas"
@onready var guide_canvas: CanvasLayer = $"../GuideCanvas"

@onready var thimble_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/ThimbleCanvas"
@onready var battery_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/BatteryCanvas"
@onready var archer_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/ArcherCanvas"

@onready var range_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/RangeCanvas"
@onready var damage_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/DamageCanvas"
@onready var speed_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/SpeedCanvas"

@onready var purple_ant_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/PurpleAntCanvas"
@onready var yellow_ant_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/YellowAntCanvas"
@onready var red_ant_canvas: CanvasLayer = $"../GuideCanvas/InfoCanvases/RedAntCanvas"

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


func _on_shop_button_pressed() -> void:
	shop_canvas.show()
	#pause game???


func _on_guide_button_pressed() -> void:
	guide_canvas.show()


func _on_x_button_pressed() -> void:
	thimble_canvas.hide()
	battery_canvas.hide()
	archer_canvas.hide()
	range_canvas.hide()
	damage_canvas.hide()
	speed_canvas.hide()
	purple_ant_canvas.hide()
	yellow_ant_canvas.hide()
	red_ant_canvas.hide()


func _on_thimble_button_pressed() -> void:
	thimble_canvas.show()


func _on_back_button_pressed() -> void:
	guide_canvas.hide()


func _on_battery_button_pressed() -> void:
	battery_canvas.show()


func _on_archer_button_pressed() -> void:
	archer_canvas.show()


func _on_range_button_pressed() -> void:
	range_canvas.show()


func _on_damage_button_pressed() -> void:
	damage_canvas.show()


func _on_speed_button_pressed() -> void:
	speed_canvas.show()


func _on_purple_button_pressed() -> void:
	purple_ant_canvas.show()


func _on_yellow_button_pressed() -> void:
	yellow_ant_canvas.show()


func _on_red_button_pressed() -> void:
	red_ant_canvas.show()
