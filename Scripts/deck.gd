extends Node2D

@export var CARD_DRAW_SPEED = 0.5
const STARTING_HAND_SIZE = 5
var player_deck = ["Knight", "Archer", "Demon","Knight", "Archer", "Demon","Knight", "Archer", "Demon","Knight", "Archer", "Demon","FireBall"]
var card_database_reference
var drawn_turn_card = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_turn_card = false
	drawn_turn_card = true

func draw_card():
	if drawn_turn_card:
		# //TODO msg pop up
		print("already drawn turn card")
		return
	drawn_turn_card = true
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(player_deck.size())
	print("DRAW CARD")
	var card_scene = preload("res://Scenes/card.tscn")
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://Assets/Cards/" + card_drawn + "_Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn][1])
	new_card.card_type = card_database_reference.CARDS[card_drawn][2]
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("Card_Flip")
