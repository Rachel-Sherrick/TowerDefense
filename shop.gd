extends CanvasLayer

signal purchase(name: String, cost: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func highlight(sprite: Sprite2D, offset: float) -> void:
	sprite.modulate = Color(0.738 + offset, 0.746 + offset, 0.85 + offset, 1.0)

func _on_slot_1_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "warrior", 1)
		highlight($ShopSlots/Slot1/Sprite2D, -0.05)
		await get_tree().create_timer(0.1).timeout
		$ShopSlots/Slot1/Sprite2D.modulate = Color(0.738, 0.746, 0.85, 1.0)
		

func _on_slot_2_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "wizard", 1)
		highlight($ShopSlots/Slot2/Sprite2D, -0.05)
		await get_tree().create_timer(0.1).timeout
		$ShopSlots/Slot2/Sprite2D.modulate = Color(0.738, 0.746, 0.85, 1.0)

func _on_slot_3_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "health_potion", 1)

func _on_slot_4_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "range_potion", 1)
		#increases tower range

func _on_slot_5_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "damage_potion", 1)
		#increases tower damage points per hit

func _on_slot_6_input_event(camera: Node, event: InputEvent, shape_idx: int) -> void:
	if (
		event.is_action_pressed("click") 
	):
		emit_signal("purchase", "speed_potion", 1)
		#increases tower rate of fire / lowers cooldown


func _on_slot_1_mouse_entered() -> void:
	var og_color = $ShopSlots/Slot1/Sprite2D.modulate
	highlight($ShopSlots/Slot1/Sprite2D, 0)
	await $ShopSlots/Slot1.mouse_exited
	$ShopSlots/Slot1/Sprite2D.modulate = og_color


func _on_slot_2_mouse_entered() -> void:
	var og_color = $ShopSlots/Slot2/Sprite2D.modulate
	highlight($ShopSlots/Slot2/Sprite2D, 0)
	await $ShopSlots/Slot2.mouse_exited
	$ShopSlots/Slot2/Sprite2D.modulate = og_color
