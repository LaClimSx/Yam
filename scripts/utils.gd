extends Node
class_name Utils

static func check_number(hand: Array[int], n: int) -> int:
	return n * hand.count(n)


static func check_little_straight(hand: Array[int]) -> int:
	if arrays_match(hand, [1, 2, 3, 4, 5]):
		return Global.COMPLEX_HAND_VALUES["littleStraight"]
	return 0


static func check_big_straight(hand: Array[int]) -> int:
	if arrays_match(hand, [2, 3, 4, 5, 6]):
		return Global.COMPLEX_HAND_VALUES["bigStraight"]
	return 0

#If three of a kind, return the sum of all dice
static func check_triangle(hand: Array[int]) -> int:
	var freq = frequency_array(hand)[0]
	if freq[1] >= 3:
		return sum_array(hand)
	return 0

#If full (yam included)
static func check_full(hand: Array[int]) -> int:
	var freq = frequency_array(hand)
	if freq[0][1] == 5 or (freq[0][1] == 3 and freq[1][1] == 2):
		return Global.COMPLEX_HAND_VALUES["full"]
	return 0


static func check_square(hand: Array[int]) -> int:
	var freq = frequency_array(hand)[0]
	if freq[1] >= 4:
		return Global.COMPLEX_HAND_VALUES["square"]
	return 0


static func check_yam(hand: Array[int]) -> int:
	var freq = frequency_array(hand)[0]
	if freq[1] >= 5:
		return Global.COMPLEX_HAND_VALUES["yam"]
	return 0


static func check_plus(hand: Array[int], minus: int = 0) -> int:
	var sum : int = sum_array(hand)
	return sum if sum >= minus else 0


static func check_minus(hand: Array[int], plus: int = 0) -> int:
	var sum : int = sum_array(hand)
	return sum if (sum <= plus or plus == 0) else 0


#Checks if two arrays have the same unordered content
static func arrays_match(ar1: Array, ar2: Array) -> bool:
	var a1 = ar1.duplicate()
	var a2 = ar2.duplicate()
	a1.sort()
	a2.sort()
	return a1 == a2


static func sum_array(ar: Array[int]) -> int:
	return ar.reduce(func(acc, n): return acc + n, 0)

#Returns an array of pairs (element, occurences) sorted by decreasing number of occurences
static func frequency_array(ar: Array) -> Array:
	var freq_dict = {}
	for elem in ar:
		freq_dict[elem] = freq_dict.get_or_add(elem, 0) + 1
	var pairs = []
	for key in freq_dict:
		pairs.append([key, freq_dict[key]])
	pairs.sort_custom(func(a, b) : return a[1] > b[1])
	return pairs
	
