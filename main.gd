extends Node

@export var enemy_scene: PackedScene
var score
var current_key: Node = null

func _ready():
	add_to_group("game")
	$HUD.connect("begin_game", Callable(self, "_on_begin_game_pressed"))
	new_game()

func _on_begin_game_pressed():
	new_game()
	$Player.can_move = true

var is_game_over = false

func game_over() -> void:
	if current_key != null and current_key.is_inside_tree():
		current_key.queue_free()  # Remove old key
	
	$EnemyTimer.stop()
	$HUD.show_game_over()
	
	var key_scene = preload("res://key.tscn")
	current_key = key_scene.instantiate()
	add_child(current_key)  # add_child first

func new_game():
	if current_key != null and current_key.is_inside_tree():
		current_key.queue_free()
	current_key = null

	is_game_over = false
	score = 0
	$Player._start($StartPosition.position)
	$StartTimer.start()
	
	get_tree().call_group("enemies", "queue_free")

func _on_start_timer_timeout() -> void:
	$EnemyTimer.start()

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()

	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	# Get and clamp spawn position BEFORE assigning to enemy
	var spawn_pos = enemy_spawn_location.position
	
	var direction = enemy_spawn_location.rotation + PI / 2
	enemy.rotation = direction

	var velocity = Vector2(200, 0)
	enemy.linear_velocity = velocity.rotated(direction)

	var margin = 20
	spawn_pos.x = clamp(spawn_pos.x, margin, 480 - margin)
	spawn_pos.y = clamp(spawn_pos.y, margin, 720 - margin)

	enemy.position = spawn_pos  # Now it uses the clamped position

	add_child(enemy)

func game_win():
	$EnemyTimer.stop()
	$StartTimer.stop()
	$HUD.show_game_win()

	print("You won the game!")

	get_tree().call_group("enemies", "queue_free")
	$Player.hide()
	$Player.can_move = false  # Freeze movement
