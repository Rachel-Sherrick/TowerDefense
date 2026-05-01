extends Character
class_name Tower

func _ready() -> void:
	velocity = Vector3.ZERO

func _process(delta: float) -> void:
	currentTarget = target()

func _physics_process(delta: float) -> void:
	super(delta)

func deal_damage(enemy):
	pass

##sets the target for the towers
func target():
	if tracking_array.is_empty(): 
		return null
	else: 
		match get_target_type():
			## targeting specfics could be handled by sub functions
			FIRST:
				#the latest body to enter the array
				return findFirst()
			LAST:
				#the oldest body in the array
				return findLast()
			CLOSE:
				return findClosest()
			STRONG: 
				return null
			WEAK: 
				return null
				
## finds the closest enemy to the tower by looping through the tracking array and comparing distances
func findClosest(): 
	var closestEnemy = findFirst()
	if !tracking_array.is_empty(): 
		for item in tracking_array: 
			if get_distance_char(item) < get_distance_char(closestEnemy): 
				closestEnemy = item
	return closestEnemy
##finds the first enemy to enter the array 
func findFirst() -> Character: 
	var firstEnemy
	if !tracking_array.is_empty(): 
		firstEnemy = tracking_array[0]
	return firstEnemy
##finds the oldest enemy in the array
func findLast(): 
	var lastEnemy
	var index
	if !tracking_array.is_empty(): 
		lastEnemy = tracking_array[-1]
	return lastEnemy
## finds the strongest Enemy
func findStrongest(): 
	var strongestEnemy
	if !tracking_array.is_empty(): 
		for item in tracking_array: 
			pass
			##compare strength attributes here, simlar to find closest
##finds the weakest Enemy
func findWeakest(): 
	var weakestEnemy
	if !tracking_array.is_empty(): 
		for item in tracking_array: 
			pass
			##compare strength attributes here


func _on_option_button_item_selected(index):
	set_target_type(index)
