extends Control

@onready var highscore_label = $ScoreContainer/BestScore
@onready var current_score_label = $ScoreContainer/CurrentScore
@onready var start_button = $MenuContainer/start_button
@onready var quit_button = $MenuContainer/quit_button

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	# Setting label text
	highscore_label.text = str(Global.get_highscore())
	current_score_label.text = str(Global.get_last_score())

func _on_start_button_pressed():
	# Transition to the game scene
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	Global.game_restart.emit()
	
func _on_quit_button_pressed():
	get_tree().quit()
