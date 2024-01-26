extends AudioStreamPlayer


func _ready():
	finished.connect(_on_finished_audio)
	autoplay = true
	play()
	


func _on_finished_audio():
	play()
