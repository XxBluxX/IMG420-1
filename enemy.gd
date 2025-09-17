extends RigidBody2D

var has_entered_screen := false

func _ready():
	$VisibleOnScreenNotifier2D.connect("screen_entered", Callable(self, "_on_screen_entered"))
	$VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "_on_screen_exited"))

func _on_screen_entered():
	has_entered_screen = true

func _on_screen_exited():
	if has_entered_screen:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
