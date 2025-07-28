extends Control


func _ready():
	if !Global.ready:
		await Global.ready


func _on_start_pressed():
	$PlayerSettings.visible = true
	for button in $Buttons.get_children():
		button.disabled = true


func _on_minus_pressed():
	Global.player_nb = clamp(Global.player_nb - 1, 1, Global.MAX_PLAYER_NB)
	$PlayerSettings/VBoxContainer/HBoxContainer/Count.text = str(Global.player_nb)


func _on_plus_pressed():
	Global.player_nb = clamp(Global.player_nb + 1, 1, Global.MAX_PLAYER_NB)
	$PlayerSettings/VBoxContainer/HBoxContainer/Count.text = str(Global.player_nb)


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
