extends Node3D

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
	
	if result:
		_spawn_tower(result.position)
		
func _spawn_tower(position: Vector3) -> void:
	var tower := tower_scene.instantiate()
	get_parent().add_child(tower)
	tower.global_position = position
