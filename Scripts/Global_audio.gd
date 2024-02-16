extends AudioStreamPlayer

const sound1 = preload("res://Assets/Sounds/background_sound.wav")
const sound2 = preload("res://Assets/Sounds/game_over.wav")
var music_bus = AudioServer.get_bus_index("Master")

func _ready():
	finished.connect(_on_finished_audio)
	Global.game_over_sound.connect(_on_game_over_sound)
	Global.game_restart.connect(_on_game_restart)
	Global.sound_button_pressed.connect(_on_sound_button_pressed)
	autoplay = true
	stream = sound1
	play()
	if Global.get_sound_option():
		AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
		
func _on_sound_button_pressed():
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
		
		
func _on_game_over_sound():
	stream = sound2
	play()
	
func _on_game_restart():
	stream = sound1
	play()
	
func _on_finished_audio():
	if stream != sound2:
		play()
