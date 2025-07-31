extends VBoxContainer
class_name Player

signal turn_finished

#We could alternatively use "find_children" with the type Button but it would be slower
@onready var score_buttons : Array[Button] = [$One, $Two, $Three, $Four, $Five, $Six, $LittleStraight, $BigStraight, $Triangle, $Full, $Square, $Yam, $Plus, $Minus]
var score: Dictionary = {}


func _ready():
	for button : Button in score_buttons:
		button.connect("pressed", func() -> void: button_pressed(button))

#For each hand type, we checked if it has already been played. If so, it stays disabled. Else, we enable the button and set its label to the potential score of the hand
func set_labels(hand: Array[int]):
	#Normal hands
	for i in range(6):
		if !score.has(Global.HANDS[i]):
			score_buttons[i].text = str(Utils.check_number(hand, i + 1))
			score_buttons[i].disabled = false
	#Complex hands
	#NB: Could probably be better in terms of code reuse
	if !score.has(Global.HANDS[6]):
		score_buttons[6].text = str(Utils.check_little_straight(hand))
		score_buttons[6].disabled = false
	if !score.has(Global.HANDS[7]):
		score_buttons[7].text = str(Utils.check_big_straight(hand))
		score_buttons[7].disabled = false
	if !score.has(Global.HANDS[8]):
		score_buttons[8].text = str(Utils.check_triangle(hand))
		score_buttons[8].disabled = false
	if !score.has(Global.HANDS[9]):
		score_buttons[9].text = str(Utils.check_full(hand))
		score_buttons[9].disabled = false
	if !score.has(Global.HANDS[10]):
		score_buttons[10].text = str(Utils.check_square(hand))
		score_buttons[10].disabled = false
	if !score.has(Global.HANDS[11]):
		score_buttons[11].text = str(Utils.check_yam(hand))
		score_buttons[11].disabled = false
	if !score.has(Global.HANDS[12]):
		var minus = score[Global.HANDS[13]] if score.has(Global.HANDS[13]) else 0
		score_buttons[12].text = str(Utils.check_plus(hand, minus))
		score_buttons[12].disabled = false
	if !score.has(Global.HANDS[13]):
		var plus = score[Global.HANDS[12]] if score.has(Global.HANDS[12]) else 0
		score_buttons[13].text = str(Utils.check_minus(hand, plus))
		score_buttons[13].disabled = false


func disable():
	for button in score_buttons:
		button.disabled = true


func button_pressed(button: Button):
	var curr_score : int = int(button.text)
	var hand = button.name.to_camel_case()
	score[hand] = curr_score
	turn_finished.emit()
	print("hand: ", hand)
