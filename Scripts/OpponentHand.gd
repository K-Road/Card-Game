extends Node2D

const CARD_WIDTH = 160
const HAND_Y_POSITION = -30
const DEFAULT_CARD_MOVE_SPEED = 0.1

var opponent_hand = []
var centre_screen_x 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centre_screen_x = get_viewport().size.x / 2

		

func add_card_to_hand(card, speed):
	if card not in opponent_hand:
		opponent_hand.insert(0,card)
		update_hand_position(speed)
	else:
		animate_card_to_position(card, card.position_in_hand, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_position(speed):
	for i in range(opponent_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = opponent_hand[i]
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position, speed)

func remove_card_from_hand(card):
	if card in opponent_hand:
		opponent_hand.erase(card)
		update_hand_position(DEFAULT_CARD_MOVE_SPEED)

func calculate_card_position(index):
	var total_width = (opponent_hand.size() -1) * CARD_WIDTH
	var x_offset = centre_screen_x - index * CARD_WIDTH + total_width/2
	return x_offset
	
func animate_card_to_position(card, new_position,speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
