extends Panel

var health = 0

onready var heart = $heart
onready var heart2 = $heart2
onready var heart3 = $heart3
onready var animation_player = $AnimationPlayer


func _ready():
	health = 3
	var _player_path = get_node(@"../../../Level/Player")
	_player_path.connect("decrease_health", self, "_decrease_health")


func _decrease_health():
	if heart.visible:
		animation_player.play("heart1")
	elif heart2.visible:
		animation_player.play("heart2")
	elif heart3.visible:
		animation_player.play("heart3")

