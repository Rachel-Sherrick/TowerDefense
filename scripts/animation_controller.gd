extends Node3D
class_name AnimationController

@onready var sprite = $SpriteBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_wizard_firing():
	sprite.play("readying attack")
	await sprite.animation_finished
	sprite.play("firing attack")
	await sprite.animation_finished
	sprite.play_backwards("readying attack")


func _on_sprite_body_animation_finished():
	true
