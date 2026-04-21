extends AnimationController
signal animation_finished()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("idle")
	animation_align()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Corrects the animation sprites rotation and position

func animation_align() -> bool:
	$SpriteSword.show()
	match $SpriteBody.animation:
		"swing_north":
			$SpriteSword.position = Vector3(-0.1,1, -0.2)
			$SpriteSword.rotation_degrees = Vector3(-45, -0.4, -180.4)
			$SpriteSword.play("swing")
			position = Vector3(0.0, 0.4, -0.3)
			return true
		"swing_east":
			$SpriteSword.position = Vector3(0.6,0.1, 0.25)
			$SpriteSword.rotation_degrees = Vector3(-45, -0.4, -0.4 + 90)
			$SpriteSword.play("swing")
			position = Vector3(0.0, 0.4, -0.3)
			return true
		"swing_west":
			$SpriteSword.position = Vector3(-0.6,0.1, 0.25)
			$SpriteSword.rotation_degrees = Vector3(-45, -0.4, -0.4 - 90)
			$SpriteSword.play("swing")
			position = Vector3(0.0, 0.4, -0.3)
			return true
		"swing_south":
			$SpriteSword.position = Vector3(-0.1,-0.4, 1.6)
			$SpriteSword.rotation_degrees = Vector3(-27.5, -0.4, -0.4)
			#to change which side sword is swung, rotate sword 90 deg
			$SpriteSword.play("swing")
			position = Vector3(0.0, 0.4, -0.3)
			return true
		_:
			$SpriteSword.hide()
			position = Vector3(0.0, 0.8, -0.9)
			return false

func play(animation: String) -> bool:
	$SpriteBody.play(animation)
	return true

func get_animation() -> String:
	return $SpriteBody.animation

## stops and resets all animations
func stop() -> bool:
	$SpriteBody.stop()
	$SpriteSword.stop()
	return true

func _on_sprite_body_animation_changed() -> void:
	animation_align()

func _on_sprite_body_animation_finished() -> void:
	print("Animation finished")
	stop()
	$SpriteSword.hide()
	emit_signal("animation_finished")
