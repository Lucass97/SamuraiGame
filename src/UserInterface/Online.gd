extends Control

onready var login_buttom = $ColorRect/CenterContainer/VBoxContainer/Login
onready var register_button = $ColorRect/CenterContainer/VBoxContainer/Register
onready var leaderboard = $ColorRect/CenterContainer/VBoxContainer/Leaderboard

func _ready():
	
	if Firebase.is_logged:
		register_button.disabled = true
		login_buttom.set_text("logout")
	else:
		leaderboard.disabled = true
		login_buttom.set_text("login")


func _on_Login_pressed():
	if Firebase.is_logged:
		Firebase.logout()
		return get_tree().reload_current_scene()
		
	return get_tree().change_scene("res://src/UserInterface/Login.tscn")


func _on_Register_pressed():
	return get_tree().change_scene("res://src/UserInterface/Register.tscn")


func _on_Leaderboard_pressed():
	return get_tree().change_scene("res://src/UserInterface/Leaderboard.tscn")


func _on_Back_pressed():
	return get_tree().change_scene("res://src/UserInterface/MainMenu.tscn")
