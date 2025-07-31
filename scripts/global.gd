extends Node

#Values of hands : 
#For normal hands : the number of points is the number of occurences of the die times the value of the die
#For complex hands : Straights are 30, three of a kind (triangle) is the sum of all the dice, full is 25, four of a kind (square) is 40, and yahtzee (yam) is 50 
#Plus and minus are personal additions, they are worth the sum of all the dice, but you can only score one if you haven't scored the other or if its value is superior (respectively inferior) or equal to the other one.
@export var HANDS : Array[String] = ["one", "two", "three", "four", "five", "six", "littleStraight", "bigStraight", "triangle", "full", "square", "yam", "plus", "minus"]
@export var COMPLEX_HAND_VALUES : Dictionary[String, int] = {"littleStraight": 30, "bigStraight": 30, "triangle": 0, "full": 25, "square": 40, "yam": 50, "plus": 0, "minus": 0}

@export var MAX_PLAYER_NB = 6
var player_nb : int = 1
