extends CanvasLayer

signal begin_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over!")
	await $MessageTimer.timeout
	
	$Message.text = "Collect The Key and Avoid The Spiders"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$BeginButton.show()

func _on_begin_button_pressed() -> void:
	$BeginButton.hide()
	$Message.hide()
	begin_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()

func game_win():
	$EnemyTimer.stop()
	$StartTimer.stop()
	$HUD.show_game_win()

	print("You won the game!")

	get_tree().call_group("enemies", "queue_free")
	$Player.hide()
	$Player.can_move = false  # Freeze movement

func show_game_win():
	$Message.text = "You Win!"
	$Message.show()

	await get_tree().create_timer(1.0).timeout  # Optional pause
	$Message.show()
