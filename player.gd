extends Area2D

signal hit

@export var speed = 200
var screen_size
var spawn_pos = Vector2(100, 100)
var can_move = false

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("player")

func _process(delta):
	if not can_move:
		return
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

var has_died = false

func _on_body_entered(body) -> void:
	if has_died:
		return

	if body.is_in_group("enemies"):
		has_died = true
		print("Player collided with enemy. Game over!")
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		get_tree().call_group("game", "game_over")

func _start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	has_died = false
