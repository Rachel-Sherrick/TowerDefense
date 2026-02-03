extends Character
class_name Tower

@onready var ray_cast_3d: RayCast3D = $RayCast3D
var enemy : Character = null
var time_elapsed : float = 1.0

func _process(delta: float) -> void:
	time_elapsed += delta
	#if raycast collides with enemy
	if ray_cast_3d.attack == true:
		deal_damage()

func _physics_process(delta: float) -> void:
	super(delta)
	
func deal_damage():
	enemy = ray_cast_3d.target
	if time_elapsed >= 1.0:
		enemy.health -= 1
		print("Enemy health ", enemy.health)
		time_elapsed = 0.0
	ray_cast_3d.attack = false
