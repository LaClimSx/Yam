extends Control

@export var HANDS = ["one", "two", "three", "four", "five", "six", "littleStraight", "bigStraight", "triangle", "full", "square", "yam", "plus", "minus"]

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var diceButtons : Array[TextureButton]
var animations : Array[AnimatedSprite2D]
var grid : Panel

var turn : int = 0
var current_player : int = 0


var hand : Array[int] = []
var throw = 0

func _ready():
	grid = $Grid
	diceButtons = [$Board/Dice/MarginContainer/BoxContainer/D1, $Board/Dice/MarginContainer/BoxContainer/D2, $Board/Dice/MarginContainer/BoxContainer/D3, $Board/Dice/MarginContainer/BoxContainer/D4, $Board/Dice/MarginContainer/BoxContainer/D5]
	animations = [$Board/Dice/MarginContainer/BoxContainer/Animations/AnimD1, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD2, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD3, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD4, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD5]
	game()
	
	
func game():
	while turn < HANDS.size():
		while current_player < Global.player_nb:
			play_turn()
			current_player += 1
		current_player = 0
		turn += 1
	#get_tree().quit()
		
func play_turn():
	throw = 0
	animate([true, true, true, true, true])
	hand = get_rands(5)
	draw_hand()
	
func get_rands(n: int):
	var result : Array[int] = []
	for i in range(n):
		result.append(rng.randi_range(1,6))
	return result

func animate(chosen_dice: Array[bool]):
	get_tree().create_timer(3).connect("timeout", func() -> void : stop_animation())
	for dieButton in diceButtons:
		dieButton.visible = false
	for i in range(5):
		var die : AnimatedSprite2D = animations[i]
		if chosen_dice[i]:
			die.visible = true
			die.play(&"", 2.0)
		else: #can be removed if works properly
			die.visible = false
			
func stop_animation():
	for die : AnimatedSprite2D in animations:
		die.visible = false
		die.pause()
	for dieButton in diceButtons:
		dieButton.visible = true


func draw_hand():
	for i in range(5):
		var die : TextureButton = diceButtons[i]
		var path : String = "res://art/visual/dice/d" + str(hand[i]) + ".tres"
		die.texture_normal = load(path)
		die.texture_hover = load(path)

func _on_close_pressed():
	grid.visible = false


func _on_sort_button_pressed():
	hand.sort()
	draw_hand()
