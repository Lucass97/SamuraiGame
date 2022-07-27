extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username : LineEdit = $ColorRect/CenterContainer/VBoxContainer/Username/LineEdit
onready var password : LineEdit = $ColorRect/CenterContainer/VBoxContainer/Password/LineEdit
onready var notification : Label = $ColorRect/CenterContainer/VBoxContainer/Notification

var score := {
	"total_score": {'stringValue': 'a'}
}


func _on_Login_pressed():
	if username.text.empty() or password.text.empty():
		notification.text = "Please, enter your username and password"
		return
	Firebase.login(username.text, password.text, http)


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		print("Sign in sucessful!")
		notification.text = "Sign in sucessful!"
	yield(get_tree().create_timer(1.5), "timeout")

func _on_Back_pressed():
	return get_tree().change_scene("res://src/UserInterface/Online.tscn")
