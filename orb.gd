extends Tower
class_name Orb

signal orb_destroyed()

func _physics_process(delta: float) -> void:
	super(delta)
	print("Orb health is ", get_health())

func _on_health_died() -> void:
	emit_signal("orb_destroyed")
