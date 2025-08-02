extends AudioStreamPlayer2D

var rolling_sounds : Array = [preload("res://art/sound/dice_roll1.mp3"), preload("res://art/sound/dice_roll2.mp3"), preload("res://art/sound/dice_roll3.mp3")]
var rng = RandomNumberGenerator.new()

func play_sound(sound_name: String):
	if !Global.sound_on: return
	pitch_scale = rng.randf_range(0.9, 1.1)
	match sound_name:
		"click":
			stream = preload("res://art/sound/click_sound.mp3")
			play()
		"roll":
			stream = rolling_sounds.pick_random()
			play()
		_:
			return
		
