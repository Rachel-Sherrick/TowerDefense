extends Character
class_name Tower

## @onready var ray_cast_3d: RayCast3D = $RayCast3D
## var enemy : Character = null
var time_elapsed : float = 0.0

#func _process(delta: float) -> void:
	#time_elapsed += delta
	
func _physics_process(delta: float) -> void:
	super(delta)
#
func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)
#
#func _on_range_body_entered(body: Node3D) -> void:
	##super(body)

#func deal_damage(enemy):
#	if time_elapsed >= 1.0:
#		enemy.health -= 1
#		print("Enemy health ", enemy.health)
#		time_elapsed = 0.0
