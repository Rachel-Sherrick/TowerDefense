extends AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("swing_south")
	animation_position_fix()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_animation_changed() -> void:
	animation_position_fix()
	
func animation_position_fix() -> bool:
	if animation == "swing_south":
		position = Vector3(0.0, 0.4, -0.3)
		return true
	else:
		position = Vector3(0.0, 0.8, -0.9)
		return false
