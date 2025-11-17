extends VBoxContainer
class_name SettingsPanel

signal closed(play_sound: bool)

func update():
	$PanelContainer/MarginContainer/VBoxContainer/SpeedVBox/SpeedSlider.value = Global.max_rolling_time
	$PanelContainer/MarginContainer/VBoxContainer/SoundSettings.button_pressed = Global.sound_on

func on_close_settings_pressed(play_sound: bool = true):
	if play_sound:
		AudioPlayer.play_sound("click")
	closed.emit(play_sound)
	visible = false


func _on_speed_slider_drag_ended(value_changed):
	if value_changed:
		Global.max_rolling_time = $PanelContainer/MarginContainer/VBoxContainer/SpeedVBox/SpeedSlider.value


func _on_sound_settings_toggled(_toggled_on):
	Global.sound_on = not Global.sound_on
	AudioPlayer.play_sound("click")


func _on_menu_button_pressed():
	AudioPlayer.play_sound("click")
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
