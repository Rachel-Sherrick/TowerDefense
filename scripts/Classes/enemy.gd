extends Character
class_name Enemy

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	super(delta)
	movement()

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)

# Moves the enemy
func movement() -> void:
	var variation = randf_range(.5, -.5)
	self.position.z += lerp(variation, variation, .1)

	if self.position.x < 30:
		self.position.x += 0.1
	else:
		attackingTowers()
		self.position.x = -30

# Damages the player towers when the enemy reaches the end
func attackingTowers() -> void:
	var scene = get_tree().current_scene
	if scene == null:
		return

	var tower_1 = scene.get_node_or_null("Tower")
	var tower_2 = scene.get_node_or_null("Tower2")

	if tower_1 != null:
		tower_1.take_damage(2)

	if tower_2 != null:
		tower_2.take_damage(2)
