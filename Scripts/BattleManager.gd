extends Node

const DEFAULT_CARD_MOVE_SPEED = 0.1
const DEFAULT_CARD_SLOT_SCALE = 0.6

var battle_timer
var empty_monster_card_slots = []
var empty_magic_card_slots = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	for i in $"../CardSlots/Opponent".get_children():
		if i.card_slot_type == "Monster":
			empty_monster_card_slots.append(i)
			print(i.card_slot_type)
		elif i.card_slot_type == "Magic":
			empty_magic_card_slots.append(i)
			print(i.card_slot_type)
	print(empty_monster_card_slots.size())
	

func _on_end_turn_button_pressed() -> void:
	opponents_turn()

func opponents_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
		#wait 1 second
	battle_timer.start()
	await battle_timer.timeout
	
	if $"../OpponentDeck".opponent_deck.size() != 0:
		$"../OpponentDeck".draw_card()
		#wait 1 second
		battle_timer.start()
		await battle_timer.timeout
	
	#check if free card slot   #checking only for monster
	if empty_monster_card_slots.size() == 0: #add magic card
		end_opponent_turn()
		return
	
	#play card
	var opponent_hand = $"../OpponentHand".opponent_hand
	if opponent_hand.size() == 0: #if hand empty end turn
		end_opponent_turn()
		return
		
	#analyse hand  Counts number of card types (Monster, Magic)
	var type_counts = {}
	for card in opponent_hand:
		var type_name = card.card_type  # Get the type of the card
		if type_name in type_counts:
			type_counts[type_name] += 1
		else:
			type_counts[type_name] = 1
	
	if "Monster" in type_counts:
		var random_empty_monster_card_slot = empty_monster_card_slots[randi_range(0,empty_monster_card_slots.size()-1)]
		empty_monster_card_slots.erase(random_empty_monster_card_slot)
		
		#find highest attack card
		var card_with_highest_attack = null
		for card in opponent_hand:
			if card.card_type == "Monster":
				if card_with_highest_attack == null or card.attack > card_with_highest_attack.attack:
					card_with_highest_attack = card
		animate_card_to_position("card_slot",card_with_highest_attack, random_empty_monster_card_slot.position)
		$"../OpponentHand".remove_card_from_hand(card_with_highest_attack)
		
		#wait 1 second
		#battle_timer.start()
		#await battle_timer.timeout
		
	end_opponent_turn()
		
			
func animate_card_to_position(position_type, card, new_position):
	if position_type == "card_slot":
		var tween = get_tree().create_tween()
		tween.tween_property(card, "position", new_position, DEFAULT_CARD_MOVE_SPEED)
		var tween2 = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(DEFAULT_CARD_SLOT_SCALE,DEFAULT_CARD_SLOT_SCALE), DEFAULT_CARD_MOVE_SPEED)
		card.get_node("AnimationPlayer").play("Card_Flip")
	
func end_opponent_turn():
	$"../Deck".reset_draw()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
