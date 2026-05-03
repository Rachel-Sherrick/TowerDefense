extends AnimationController
signal fire_frame()
signal wizard_ready()
signal sprite_frame_changed(frame: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_wizard_readying():
	sprite.play("readying attack")
	await animation_finished
	print("Ready finished")
	emit_signal("wizard_ready")

func _on_attack_firing():
	sprite.play("firing attack")
	await fire_frame
	print("Fire finished")
	#emit_signal("fire_frame")

func _on_recoil():
	sprite.play_backwards("readying attack")

func _on_sprite_body_animation_finished() -> void:
	print("Animation finished")
	stop()
	emit_signal("animation_finished")
	
## stops and resets all animations
func stop() -> bool:
	$SpriteBody.stop()
	return true


func _on_sprite_body_frame_changed() -> void:
	if sprite.frame == 12:
		emit_signal("fire_frame")
