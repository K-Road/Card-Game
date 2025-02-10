extends Node2D

@export var CARD_DRAW_SPEED = 0.5
const STARTING_HAND_SIZE = 5
var opponent_deck = ["Knight", "Archer", "Demon","Knight", "Archer", "Demon","Knight", "Archer", "Demon","Knight", "Archer", "Demon","FireBall"]
var card_database_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opponent_deck.shuffle()
	$RichTextLabel.text = str(opponent_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()

func draw_card():
	if opponent_deck.size() == 0:
		return
		
	var card_drawn = opponent_deck[0]
	opponent_deck.erase(card_drawn)
	
	if opponent_deck.size() == 0:
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(opponent_deck.size())
	print("DRAW CARD")
	var card_scene = preload("res://Scenes/opponent_card.tscn")
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/Cards/" + card_drawn + "_Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.attack = card_database_reference.CARDS[card_drawn][0]
	new_card.get_node("Attack").text = str(new_card.attack)
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn][1])
	new_card.card_type = card_database_reference.CARDS[card_drawn][2]
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../OpponentHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	#new_card.get_node("AnimationPlayer").play("Card_Flip")
