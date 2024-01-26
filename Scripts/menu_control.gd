extends Control

@onready var highscore_label = $high_score_label
@onready var start_button = $MenuContainer/start_button
@onready var option_button = $MenuContainer/option_button
@onready var quit_button = $MenuContainer/quit_button

func _ready():
	highscore_label.text = "Best Score ==>" + str(Global.get_highscore())
	#connecting button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)


func _on_start_button_pressed():
	# Transition to the game scene
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()
