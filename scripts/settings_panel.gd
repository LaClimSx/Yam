extends Panel
class_name SettingsPanel

signal closed

func update():
	$SpeedSlider.value = Global.max_rolling_time
	$SoundSettings.button_pressed = Global.sound_on

func _on_close_settings_pressed():
	AudioPlayer.play_sound("click")
	closed.emit()
	visible = false


func _on_speed_slider_drag_ended(value_changed):
	if value_changed:
		Global.max_rolling_time = $SpeedSlider.value


func _on_sound_settings_toggled(toggled_on):
	AudioPlayer.play_sound("click")
	Global.sound_on = not Global.sound_on
