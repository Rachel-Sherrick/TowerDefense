extends Character
class_name Enemy

@export var target_name: String = "Orb"
@export var attack_range: float = 2.0
@export var attack_damage: int = 2
@export var attack_interval: float = 1.0

var target_tower: Node3D = null
var _attack_timer: float = 0.0

func _ready() -> void:
	super()
	_find_target()

func _physics_process(delta: float) -> void:
	if target_tower == null or !is_instance_valid(target_tower):
		_find_target()

	_move_or_attack(delta)
	super(delta)

func _find_target() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		target_tower = null
		return

	target_tower = scene.find_child(target_name, true, false) as Node3D

func _move_or_attack(delta: float) -> void:
	if target_tower == null:
		velocity = Vector3.ZERO
		return

	var dist := global_position.distance_to(target_tower.global_position)

	if dist <= attack_range:
		velocity = Vector3.ZERO
		_attack_timer -= delta
		if _attack_timer <= 0.0:
			if target_tower.has_method("take_damage"):
				target_tower.take_damage(attack_damage)
			_attack_timer = attack_interval
	else:
		_attack_timer = 0.0
		var dir := (target_tower.global_position - global_position).normalized()
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		velocity.y = 0.0
