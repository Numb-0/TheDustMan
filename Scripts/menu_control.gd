extends Control

@onready var highscore_label = $BestScore
@onready var start_button = $MenuContainer/start_button
@onready var option_button = $MenuContainer/option_button
@onready var quit_button = $MenuContainer/quit_button
@onready var difficulty_button = $OptionContainer/DifficultyButton
@onready var sound_button = $OptionContainer/SoundButton
@onready var option_menu = $OptionContainer
@onready var exit_button = $OptionContainer/ExitMenu

func _ready():
	highscore_label.text = str(Global.get_highscore())
	#connecting button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	option_button.pressed.connect(_on_option_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	option_menu.hide()
	sound_button.toggle_mode = true
	sound_button.button_pressed = Global.get_sound_option()
	sound_button.pressed.connect(_on_sound_button_pressed)
	difficulty_button.selected = Global.get_difficulty()
	difficulty_button.item_selected.connect(_on_difficulty_button_item_selected)
	

func _on_start_button_pressed():
	# Transition to the game scene
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()
	
func _on_option_button_pressed():
	start_button.hide()
	quit_button.hide()
	option_button.hide()
	option_menu.show()

func _on_exit_button_pressed():
	start_button.show()
	quit_button.show()
	option_button.show()
	option_menu.hide()
	
func _on_sound_button_pressed():
	Global.sound_button_pressed.emit()
	Global.save_sound_option(sound_button.button_pressed)
	
func _on_difficulty_button_item_selected(difficulty):
	Global.save_difficulty(difficulty)
