extends Control

@export var max_rolling_time : float = 4.0 #Make this a parameter

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var dice_buttons : Array[TextureButton] = [$Board/Dice/MarginContainer/BoxContainer/D1, $Board/Dice/MarginContainer/BoxContainer/D2, $Board/Dice/MarginContainer/BoxContainer/D3, $Board/Dice/MarginContainer/BoxContainer/D4, $Board/Dice/MarginContainer/BoxContainer/D5]
@onready var animations : Array[AnimatedSprite2D] = [$Board/Dice/MarginContainer/BoxContainer/Animations/AnimD1, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD2, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD3, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD4, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD5]
var occuring_animations : int = 0
@onready var grid : Panel = $Grid
@onready var board : Panel = $Board
@onready var players : Array[Player] = [$Grid/Players/HBoxContainer/Player1]

var turn : int = 0
var current_player : int = 0


var hand : Array[int] = [0, 0, 0, 0, 0]
var selected_dice : Array[bool] = [false, false, false, false, false] #Selecting a die means keeping it, so non selected dice get thrown again
var throw = 0

func _ready():
	for i in range(5):
		var die_button = dice_buttons[i]
		die_button.connect("pressed", func() -> void : _on_die_pressed(i))
	for i in range(Global.player_nb - 1):
		var new_player : Player = players[0].duplicate()
		$Grid/Players/HBoxContainer.add_child(new_player)
		players.append(new_player)
		new_player.get_node("Name").text = "J" + str(i + 2)
	#game()
	play_turn()
	
	
func game():
	while turn < Global.HANDS.size():
		while current_player < Global.player_nb:
			play_turn()
			current_player += 1
		current_player = 0
		turn += 1
	#get_tree().quit()


func play_turn():
	$Board/PlayerTags/PlayerNumber.text = str(current_player + 1)
	$Board/SortButton.visible = false
	$Board/ButtonsLayout/GridButton.visible = false
	for player in players:
		player.disable()
	selected_dice = [false, false, false, false, false]
	for die_button in dice_buttons : toggle_invisibility(die_button, true)
	throw = 0
	#animate([true, true, true, true, true])
	#hand = get_rands(5)
	#draw_hand()


func end_turn():
	pass



func get_rands(n: int):
	var result : Array[int] = []
	for i in range(n):
		result.append(rng.randi_range(1,6))
	return result


func animate(chosen_dice: Array[bool]):
	$Board/SortButton.disabled = true
	$Board/ButtonsLayout/ThrowButton.disabled = true
	$Board/ButtonsLayout/GridButton.disabled = true
	#for die_button in dice_buttons:
	#	die_button.visible = false
	for i in range(5):
		var die : AnimatedSprite2D = animations[i]
		if chosen_dice[i]:
			toggle_invisibility(dice_buttons[i], true)
			die.visible = true
			die.play(&"", 2.0)
			get_tree().create_timer(rng.randf_range(1.0, max_rolling_time)).connect("timeout", func() -> void : stop_animation(i))
			#Clamping shouldn't be necessary, doing it in case of weird data race issue
			occuring_animations = clamp(occuring_animations + 1, 0, 5)
		else: #can be removed if works properly
			die.visible = false


func stop_animation(i: int):
	occuring_animations = clamp(occuring_animations - 1, 0, 5)
	var die : AnimatedSprite2D = animations[i]
	die.visible = false
	die.pause()
	toggle_invisibility(dice_buttons[i], false)
	if occuring_animations == 0:
		$Board/SortButton.disabled = false
		$Board/ButtonsLayout/GridButton.disabled = false
		#We check here if the turn is over because it happens after the button press
		if throw < 3 :
			$Board/ButtonsLayout/ThrowButton.disabled = false


func draw_hand():
	for i in range(5):
		var die : TextureButton = dice_buttons[i]
		var path : String = "res://art/visual/dice/d" + str(hand[i]) + ".tres"
		var pink_path : String = "res://art/visual/dice/pink_d" + str(hand[i]) + ".tres"
		if selected_dice[i]:
			die.texture_normal = load(pink_path)
			die.texture_hover = load(path)
		else:
			die.texture_normal = load(path)
			die.texture_hover = load(pink_path)
		die.texture_focused = die.texture_normal
		die.texture_pressed = die.texture_hover


func _on_close_pressed():
	grid.visible = false
	board.visible = true


#Sorts the dice whilst keeping the selection
func _on_sort_button_pressed():
	var pairs : Array[Array]
	for i in range(5):
		pairs.append([hand[i], selected_dice[i]])
	pairs.sort()
	for i in range(5):
		hand[i] = pairs[i][0]
		selected_dice[i] = pairs[i][1]
	draw_hand()


func _on_grid_button_pressed():
	#Compute stuff like playable options
	board.visible = false
	grid.visible = true
	
#Toggle selection of a die button
func _on_die_pressed(i: int):
	var die_button = dice_buttons[i]
	#Swap all pink and white textures
	die_button.texture_normal = die_button.texture_pressed
	die_button.texture_pressed = die_button.texture_focused
	die_button.texture_focused = die_button.texture_normal
	#timer is used so that the player can see the change in color while keeping the mouse on the die
	get_tree().create_timer(0.4).connect("timeout", func() -> void : die_button.texture_hover = die_button.texture_pressed)
	selected_dice[i] = not selected_dice[i]


func _on_throw_button_pressed():
	$Board/SortButton.visible = true
	$Board/ButtonsLayout/GridButton.visible = true
	var selected_nb : int = selected_dice.count(true)
	if selected_nb == 5:
		return
	throw += 1
	var rands = get_rands(5 - selected_nb)
	for i in range(5):
		if !selected_dice[i]:
			hand[i] = rands.pop_back()
	var to_be_thrown : Array[bool] = []
	for b in selected_dice: to_be_thrown.append(not b) 
	var player = players[current_player]
	####################TESTING###############
	#print("hand: ", hand)
	#print("one: ", Utils.check_number(hand, 1))
	#print("two: ", Utils.check_number(hand, 2))
	#print("three: ", Utils.check_number(hand, 3))
	#print("four: ", Utils.check_number(hand, 4))
	#print("five: ", Utils.check_number(hand, 5))
	#print("six: ", Utils.check_number(hand, 6))
	#
	#print("littleStraight: ", Utils.check_little_straight(hand))
	#print("bigStraight: ", Utils.check_big_straight(hand))
	#print("triangle: ", Utils.check_triangle(hand))
	#print("full: ", Utils.check_full(hand))
	#print("square: ", Utils.check_square(hand))
	#print("yam: ", Utils.check_yam(hand))
	#print("plus: ", Utils.check_plus(hand))
	#print("minus: ", Utils.check_minus(hand))
	####################END TESTING###########
	player.set_labels(hand)
	animate(to_be_thrown)
	draw_hand()

#We use this so that the container doesn't resize when we set the node to invisible
func toggle_invisibility(node: Control, hide: bool):
	if hide:
		node.modulate.a = 0.0
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		node.modulate.a = 1.0
		node.mouse_filter = Control.MOUSE_FILTER_STOP
		
