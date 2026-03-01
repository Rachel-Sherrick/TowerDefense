extends Character
class_name Tower

func _physics_process(delta: float) -> void:
	super(delta)
#
func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)
#
#func _on_range_body_entered(body: Node3D) -> void:
	##super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)

func deal_damage(enemy):
	pass
