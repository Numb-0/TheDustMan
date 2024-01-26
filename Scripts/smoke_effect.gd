extends AnimatedSprite2D


func _ready():
	animation_finished.connect(_on_animation_finished)
	frame = 0
	play("smoke")


func _on_animation_finished():
	queue_free()
