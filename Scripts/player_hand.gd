extends Node2D

const CARD_WIDTH = 200
const HAND_Y_POSITION = 890
const DEFAULT_CARD_MOVE_SPEED = 0.1

var player_hand = []
var centre_screen_x 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen_x = get_viewport().size.x / 2

		

func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_position(speed)
	else:
		animate_card_to_position(card, card.position_in_hand, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_position(speed):
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_position(DEFAULT_CARD_MOVE_SPEED)

func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = centre_screen_x + index * CARD_WIDTH - total_width/2
	return x_offset
	
func animate_card_to_position(card, new_position,speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
