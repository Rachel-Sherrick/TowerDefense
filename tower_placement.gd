extends Node3D

signal tower_placed(tower: Tower)
@export var tower_scene: PackedScene

func _place_tower(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		var tower: Tower = tower_scene.instantiate()
		get_parent().get_node("Characters").add_child(tower)
		tower.global_position = Vector3(event_position.x, 0, event_position.z)
		print(tower.name + " spawned at ", event_position)
		emit_signal("tower_placed", tower)
