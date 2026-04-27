extends Node3D
class_name AnimationController

signal animation_finished()
@onready var sprite: AnimatedSprite3D = $SpriteBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func get_animation() -> String:
	return $SpriteBody.animation

func play(animation: String) -> bool:
	$SpriteBody.play(animation)
	return true

func _on_sprite_body_animation_finished():
	$SpriteBody.modulate = Color(1.0, 1.0, 1.0, 1.0)
	sprite.stop()
	emit_signal("animation_finished")
	
func _on_health_took_damage(health_lost: int) -> void:
	var og_color = $SpriteBody.modulate
	$SpriteBody.modulate = Color(0.943, 0.389, 0.348, 1.0)
	await get_tree().create_timer(0.1).timeout
	$SpriteBody.modulate = og_color

## forces color change back to normal IF it gets tuck for some reason
func _on_sprite_body_animation_looped() -> void:
	$SpriteBody.modulate = Color(1.0, 1.0, 1.0, 1.0)
