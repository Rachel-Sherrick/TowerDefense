extends Character
class_name Tower

## @onready var ray_cast_3d: RayCast3D = $RayCast3D
## var enemy : Character = null
var time_elapsed : float = 1.0

func _process(delta: float) -> void:
	time_elapsed += delta
	#if raycast collides with enemy

func _physics_process(delta: float) -> void:
	super(delta)

func _on_ray_cast_3d_detect_foe(body: CollisionObject3D) -> void:
	print(name + " detected " + body.name)
	deal_damage(body)

func _on_ray_cast_3d_detect_friend(body: CollisionObject3D) -> void:
	super(body)

func deal_damage(enemy):
	if time_elapsed >= 1.0:
		enemy.health -= 1
		print("Enemy health ", enemy.health)
		time_elapsed = 0.0
