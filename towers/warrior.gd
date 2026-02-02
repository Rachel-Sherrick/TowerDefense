extends Tower
class_name Warrior

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_body_entered(body: Node3D) -> void:
		if body.is_in_group("Enemy") :
			pass
		pass
