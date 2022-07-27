extends ScrollContainer


export(float, 0.5, 1, 0.1) onready var card_scale = 0.4
export(float, 1, 1.5, 0.1) onready var card_current_scale = 0.6
export(float, 0.1, 1, 0.1) onready var scroll_duration = 1.3

var card_current_index: int = 0
var card_x_positions: Array = []

onready var scroll_tween: Tween = Tween.new()
onready var margin_r: int = $CenterContainer/MarginContainer.get("custom_constants/margin_right")
onready var card_space: int = $CenterContainer/MarginContainer/HBoxContainer.get("custom_constants/separation")
onready var card_nodes: Array = $CenterContainer/MarginContainer/HBoxContainer.get_children()
onready var levels_list: Array = ["level1", "level2"]


func _ready() -> void:
	
	add_child(scroll_tween)
	yield(get_tree(), "idle_frame")
	
	get_h_scrollbar().modulate.a = 0
	
	var i = 0
	for _card in card_nodes:
		var _card_pos_x: float = (margin_r + _card.rect_position.x) - ((rect_size.x - _card.rect_size.x) / 2)
		_card.rect_pivot_offset = (_card.rect_size / 2)
		card_x_positions.append(_card_pos_x)
		
		var counters = _card.get_node(@"GridContainer").get_children()
		
		# Impostazioni per ogni counter
		for counter in counters:
			counter.level_name = levels_list[i]
			counter.stats = Stats.record_stats
			counter.update_text()
			
		var completed_label = _card.get_node(@"Completed")
		completed_label.level_name = levels_list[i]
		completed_label.stats = Stats.record_stats
		completed_label.update_text()
		
		i +=1
		
	scroll_horizontal = card_x_positions[card_current_index]
	scroll()


func _process(_delta: float) -> void:
	
	for _index in range(card_x_positions.size()):
		var _card_pos_x: float = card_x_positions[_index]
		var _swipe_length: float = (card_nodes[_index].rect_size.x / 2) + (card_space / 2)
		var _swipe_current_length: float = abs(_card_pos_x - scroll_horizontal)
		var _card_scale: float = range_lerp(_swipe_current_length, _swipe_length, 0, card_scale, card_current_scale)
		var _card_opacity: float = range_lerp(_swipe_current_length, _swipe_length, 0, 0.3, 1)
		
		_card_scale = clamp(_card_scale, card_scale, card_current_scale)
		_card_opacity = clamp(_card_opacity, 0.3, 1)
		
		card_nodes[_index].rect_scale = Vector2(_card_scale, _card_scale)
		card_nodes[_index].modulate.a = _card_opacity
		
		if _swipe_current_length < _swipe_length:
			card_current_index = _index


func scroll() -> void:
	
	scroll_tween.interpolate_property(
		self,
		"scroll_horizontal",
		scroll_horizontal,
		card_x_positions[card_current_index],
		scroll_duration,
		Tween.TRANS_BACK,
		Tween.EASE_OUT)
	
	for _index in range(card_nodes.size()):
		var _card_scale: float = card_current_scale if _index == card_current_index else card_scale
		scroll_tween.interpolate_property(
			card_nodes[_index],
			"rect_scale",
			card_nodes[_index].rect_scale,
			Vector2(_card_scale,_card_scale),
			scroll_duration,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT)
		
	scroll_tween.start()


func _on_ScrollContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			scroll_tween.stop_all()
		else:
			scroll()

func _on_CardMenu1_gui_input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			return get_tree().change_scene("res://src/Main/GameWithLevel1.tscn")

func _on_CardMenu2_gui_input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			return get_tree().change_scene("res://src/Main/GameWithLevel2.tscn")

func _on_CardMenu3_gui_input(_event):
	pass
	
func _on_CardMenu4_gui_input(_event):
	pass
