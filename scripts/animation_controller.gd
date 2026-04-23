extends Node3D
class_name AnimationController

signal animation_finished()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_health_took_damage(health_lost: int) -> void:
	var og_color = $SpriteBody.modulate
	$SpriteBody.modulate = Color(0.943, 0.389, 0.348, 1.0)
	await get_tree().create_timer(0.1).timeout
	$SpriteBody.modulate = og_color
