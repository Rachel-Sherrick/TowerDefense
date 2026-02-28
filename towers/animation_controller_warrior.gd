extends AnimationController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("swing_south")
	animation_position_fix()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animation_position_fix() -> bool:
	if $SpriteBody.animation == "swing_south":
		position = Vector3(0.0, 0.4, -0.3)
		$SpriteSword.position = Vector3(-0.1,-0.4, 1.6)
		$SpriteSword.rotation_degrees = Vector3(-27.5, -0.4, -0.4)
		#to change which side sword is swung, rotate sword 90 deg
		return true
	else:
		position = Vector3(0.0, 0.8, -0.9)
		return false

func play(animation: String) -> bool:
	$SpriteBody.play(animation)
	$SpriteSword.play(animation)
	return true


func _on_sprite_body_animation_changed() -> void:
	animation_position_fix()
