extends AnimationController
signal hurt_frame_triggered()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play(animation: String) -> bool:
	$SpriteBody.play(animation)
	return true

func get_animation() -> String:
	return $SpriteBody.animation

## stops and resets all animations
func stop() -> bool:
	$SpriteBody.stop()
	return true

func animation_align() -> void:
	pass

func _on_sprite_body_animation_changed() -> void:
	animation_align()

func _on_sprite_body_animation_finished() -> void:
	print("Animation finished")
	stop()
	emit_signal("animation_finished")


func _on_sprite_body_frame_changed() -> void:
	if $SpriteBody.frame == 12:
		emit_signal("hurt_frame_triggered")
	pass # Replace with function body.
