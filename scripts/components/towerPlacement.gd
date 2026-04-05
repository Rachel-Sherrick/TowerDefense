extends Node3D

signal tower_placed(tower: Tower)
@export var tower_scene: PackedScene

func _unhandled_input(event: InputEvent):
	if(
		event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		_place_tower(event.position)

func _place_tower(mouse_pos: Vector2) -> void:
	if tower_scene == null:
		print("No scene")
		return
		
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		print("No camera")
		return
		
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000.0
	
	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	
	if result and _is_valid_position(result.position):
		_spawn_tower(result.position)
		
func _spawn_tower(position: Vector3) -> void:
	var tower := tower_scene.instantiate()
	get_parent().get_node("Characters").add_child(tower)
	tower.global_position = position
	emit_signal("tower_placed", tower)
	
func _is_valid_position(position: Vector3) -> bool:
	var area := get_parent().get_node("PlaceableArea") as Area3D 
	var shape := area.get_node("CollisionShape3D").shape as BoxShape3D
	var extents := shape.size * 0.5
	var local_pos := area.to_local(position)
	
	return(
		abs(local_pos.x) <= extents.x and abs(local_pos.z) <= extents.z
	)
