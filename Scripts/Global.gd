extends Node


signal test

# trash bin signals
signal trash_entering_bin(body)
signal update_points(points)
signal update_health

# trash signals
signal trash_clicked(object)
var config = ConfigFile.new()

# Load data from a file.
var load_response = config.load("user://scores.cfg")

func save_high_score(score):
	if score > config.get_value("Highscore", "score", 0):
		config.set_value("Highscore", "score", score)
		config.save("user://scores.cfg")

func get_highscore():
	return config.get_value("Highscore", "score", 0)
