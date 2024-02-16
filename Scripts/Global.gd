extends Node


signal test
signal game_over_sound
signal game_restart
signal sound_button_pressed

# trash bin signals
signal trash_entering_bin(body)
signal update_points(points)
signal update_health

# trash signals
signal trash_clicked(object)

func _ready():
	get_viewport().size = DisplayServer.screen_get_size()

# util function
func wait(seconds: int) -> void:
	await get_tree().create_timer(seconds).timeout

var config = ConfigFile.new()

# Load data from a file.
var load_response = config.load("user://user_data.cfg")

func save_last_score(score):
	config.set_value("Highscore", "last_score", score)
	config.save("user://user_data.cfg")

func save_score(score):
	config.set_value("Highscore", "score", score)
	config.save("user://user_data.cfg")

func save_high_score(score):
	save_last_score(score)
	if score > config.get_value("Highscore", "score", 0):
		save_score(score)

func get_highscore():
	return config.get_value("Highscore", "score", 0)
	
func get_last_score():
	return config.get_value("Highscore", "last_score", 0)
	
func save_difficulty(value):
	config.set_value("Options", "difficulty",  value)
	config.save("user://user_data.cfg")
	
func save_sound_option(value):
	config.set_value("Options", "sound",  value)
	config.save("user://user_data.cfg")

func get_difficulty():
	# Returning 1 as default since 1 is Normal difficulty
	return config.get_value("Options", "difficulty", 1)

func get_sound_option():
	return config.get_value("Options", "sound", true)
