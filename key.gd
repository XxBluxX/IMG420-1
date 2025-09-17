extends Area2D

@export var margin: int = 50

func _ready():
	randomize()
	await get_tree().process_frame
	set_random_position()
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Player collected the key!")
		get_tree().call_group("game", "game_win")
		queue_free()  # Remove the key after collecting

func set_random_position():
	var visible_rect = get_viewport().get_visible_rect()
	var min_pos = visible_rect.position + Vector2(margin, margin)
	var max_pos = visible_rect.position + visible_rect.size - Vector2(margin, margin)
	
	var random_x = randf_range(min_pos.x, max_pos.x)
	var random_y = randf_range(min_pos.y, max_pos.y)
	global_position = Vector2(random_x, random_y)
