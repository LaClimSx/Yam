extends Control

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var dice_buttons : Array[TextureButton] = [$Board/Dice/MarginContainer/BoxContainer/D1, $Board/Dice/MarginContainer/BoxContainer/D2, $Board/Dice/MarginContainer/BoxContainer/D3, $Board/Dice/MarginContainer/BoxContainer/D4, $Board/Dice/MarginContainer/BoxContainer/D5]
@onready var animations : Array[AnimatedSprite2D] = [$Board/Dice/MarginContainer/BoxContainer/Animations/AnimD1, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD2, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD3, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD4, $Board/Dice/MarginContainer/BoxContainer/Animations/AnimD5]
var occuring_animations : int = 0
@onready var grid : VBoxContainer = $Grid
@onready var board : Panel = $Board
@onready var players : Array[Player] = [$Grid/ContainerPanel/MarginContainer/Hbox/Players/Player1]

var turn : int = 0
var current_player : int = 0

const white_dice_tex : Array[CompressedTexture2D] = [preload("res://art/visual/dice/d1.png"), preload("res://art/visual/dice/d2.png"), preload("res://art/visual/dice/d3.png"), preload("res://art/visual/dice/d4.png"), preload("res://art/visual/dice/d5.png"), preload("res://art/visual/dice/d6.png")]
const pink_dice_tex :  Array[CompressedTexture2D] = [preload("res://art/visual/dice/pink_d1.png"), preload("res://art/visual/dice/pink_d2.png"), preload("res://art/visual/dice/pink_d3.png"), preload("res://art/visual/dice/pink_d4.png"), preload("res://art/visual/dice/pink_d5.png"), preload("res://art/visual/dice/pink_d6.png")]

var hand : Array[int] = [0, 0, 0, 0, 0]
var selected_dice : Array[bool] = [false, false, false, false, false] #Selecting a die means keeping it, so non selected dice get thrown again
var throw = 0

var visibilities : Dictionary

func _ready():
	for i in range(5):
		var die_button = dice_buttons[i]
		die_button.connect("pressed", func() -> void : _on_die_pressed(i))
	for i in range(Global.player_nb - 1):
		var new_player : Player = players[0].duplicate()
		$Grid/ContainerPanel/MarginContainer/Hbox/Players.add_child(new_player)
		players.append(new_player)
		new_player.get_node("Name").text = "J" + str(i + 2)
	play_turn()


func play_turn():
	$Board/PlayerTags/PlayerNumber.text = str(current_player + 1)
	$Board/SortButton.visible = false
	$Board/ButtonsLayout/GridButton.visible = false
	$Board/ButtonsLayout/ThrowButton.disabled = false
	
	for player in players:
		player.disable()
	selected_dice = [false, false, false, false, false]
	for die_button in dice_buttons : toggle_invisibility(die_button, true)
	throw = 0


func end_turn():
	players[current_player].disable()
	_on_close_pressed()
	current_player = (current_player + 1) % Global.player_nb
	if current_player == 0:
		turn += 1
	if turn == Global.HANDS.size():
		end_game()
		return
	play_turn()



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
			die.play(&"", -2.0)
			get_tree().create_timer(rng.randf_range(1.0, Global.max_rolling_time)).connect("timeout", func() -> void : stop_animation(i))
			#Clamping shouldn't be necessary, doing it in case of weird data race issue
			occuring_animations = clamp(occuring_animations + 1, 0, 5)


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
		var white_tex = white_dice_tex[hand[i] - 1]
		var pink_tex = pink_dice_tex[hand[i] - 1]
		if selected_dice[i]:
			die.texture_normal = pink_tex
			die.texture_hover = white_tex
		else:
			die.texture_normal = white_tex
			die.texture_hover = pink_tex
		die.texture_focused = die.texture_normal
		die.texture_pressed = die.texture_hover


func end_game():
	var scores = []
	for player in players:
		scores.append(player.total)
	var maximum = scores.max()
	$EndScreen/VBoxContainer/ScoreTexts/ScoreNumber.text = str(maximum)
	var winners = []
	for i in range(scores.size()):
		if scores[i] == maximum:
			winners.append(i)
	if winners.size() == 1:
		$EndScreen/VBoxContainer/VictoryTexts/VictoryNumber.text = str(winners[0] + 1)
	else:
		#In case of equality
		$EndScreen/VBoxContainer/VictoryTexts/VictoryLabel.text = "Victoire des joueurs"
		var str_builder : String = ""
		for i in range(winners.size()):
			if i == winners.size() - 1:
				str_builder += " et "  + str(winners[i] + 1)
			elif i == winners.size() - 2:
				str_builder += str(winners[i] + 1)
			else:
				str_builder += str(winners[i] + 1) + ", "
		$EndScreen/VBoxContainer/VictoryTexts/VictoryNumber.text = str_builder
	$EndScreen.visible = true
	


func _on_close_pressed():
	AudioPlayer.play_sound("click")
	grid.visible = false
	board.visible = true


#Sorts the dice whilst keeping the selection
func _on_sort_button_pressed():
	AudioPlayer.play_sound("click")
	var pairs : Array[Array]
	for i in range(5):
		pairs.append([hand[i], selected_dice[i]])
	pairs.sort()
	for i in range(5):
		hand[i] = pairs[i][0]
		selected_dice[i] = pairs[i][1]
	draw_hand()


func _on_grid_button_pressed():
	AudioPlayer.play_sound("click")
	board.visible = false
	grid.visible = true
	
#Toggle selection of a die button
func _on_die_pressed(i: int):
	AudioPlayer.play_sound("click")
	var die_button = dice_buttons[i]
	#Swap all pink and white textures
	die_button.texture_normal = die_button.texture_pressed
	die_button.texture_pressed = die_button.texture_focused
	die_button.texture_focused = die_button.texture_normal
	#timer is used so that the player can see the change in color while keeping the mouse on the die
	get_tree().create_timer(0.4).connect("timeout", func() -> void : die_button.texture_hover = die_button.texture_pressed)
	selected_dice[i] = not selected_dice[i]


func _on_throw_button_pressed():
	AudioPlayer.play_sound("roll")
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
	player.set_labels(hand)
	animate(to_be_thrown)
	draw_hand()


func _on_menu_button_pressed():
	AudioPlayer.play_sound("click")
	Global.player_nb = 1
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_settings_button_pressed():
	AudioPlayer.play_sound("click")
	visibilities = {board: board.visible, grid: grid.visible, $EndScreen: $EndScreen.visible}
	for panel in visibilities:
		if visibilities[panel]:
			panel.visible = false
	$SettingsPanel.update()
	$SettingsPanel.visible = true


func _on_settings_panel_closed():
	AudioPlayer.play_sound("click")
	for panel in visibilities:
		if visibilities[panel]:
			panel.visible = true


#We use this so that the container doesn't resize when we set the node to invisible
func toggle_invisibility(node: Control, hide_it: bool):
	if hide_it:
		node.modulate.a = 0.0
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		node.modulate.a = 1.0
		node.mouse_filter = Control.MOUSE_FILTER_STOP
