extends Control

@export var HANDS = ["one", "two", "three", "four", "five", "six", "littleStraight", "bigStraight", "triangle", "full", "square", "yam", "plus", "minus"]
var turn : int = 0
var current_player : int = 0
var grid

var hand : Array[int] = []

func _ready():
	grid = $Grid
	#game()
	
	
func game():
	while turn < HANDS.size():
		while current_player < Global.player_nb:
			play_turn()
			current_player += 1
		current_player = 0
		turn += 1
	get_tree().quit()
		
func play_turn():
	print(current_player + 1)
	print(turn)


func _on_close_pressed():
	grid.visible = false
