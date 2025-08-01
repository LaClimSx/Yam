extends Panel
class_name SettingsPanel

func _on_close_settings_pressed():
	visible = false


func _on_speed_slider_drag_ended(value_changed):
	if value_changed:
		Global.max_rolling_time = $SpeedSlider.value


func _on_sound_settings_toggled(toggled_on):
	Global.sound_on = not Global.sound_on
