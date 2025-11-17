extends Control


func _ready():
	if !Global.ready:
		await Global.ready
	$PlayerSettings/VBoxContainer/HBoxContainer/Count.text = str(Global.player_nb)
	$SettingsPanel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/ReturnButton.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("escape"):
		if $PlayerSettings.visible:
			$PlayerSettings.visible = false
			for button in $Buttons.get_children():
				button.disabled = false
		elif $SettingsPanel.visible:
			$SettingsPanel.visible = false
		else:
			_on_quit_pressed()


func _on_start_pressed():
	AudioPlayer.play_sound("click")
	$PlayerSettings.visible = true
	for button in $Buttons.get_children():
		button.disabled = true


func _on_minus_pressed():
	AudioPlayer.play_sound("click")
	Global.player_nb = clamp(Global.player_nb - 1, 1, Global.MAX_PLAYER_NB)
	$PlayerSettings/VBoxContainer/HBoxContainer/Count.text = str(Global.player_nb)


func _on_plus_pressed():
	AudioPlayer.play_sound("click")
	Global.player_nb = clamp(Global.player_nb + 1, 1, Global.MAX_PLAYER_NB)
	$PlayerSettings/VBoxContainer/HBoxContainer/Count.text = str(Global.player_nb)


func _on_start_game_pressed():
	AudioPlayer.play_sound("click")
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_settings_pressed():
	AudioPlayer.play_sound("click")
	$SettingsPanel.update()
	$SettingsPanel.visible = true


func _on_quit_pressed():
	AudioPlayer.play_sound("click")
	get_tree().quit()
