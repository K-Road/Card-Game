extends Node2D
const COLLISON_MASK_CARD = 1

var card_being_dragged
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		print(mouse_pos)
		print(card_being_dragged.position)
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y,0,screen_size.y))
		

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("Left Click")
			var card = raycast_check_for_card()
			if card:
				card_being_dragged = card
			
		else:
			card_being_dragged = null
			print("Release Left")
			
			
			
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISON_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		print("DEBUG " + str(result[0].collider.get_parent()))
		return result[0].collider.get_parent()
	return null
