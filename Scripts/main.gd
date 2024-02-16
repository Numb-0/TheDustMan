extends Node2D

# Loading resources
@onready var points_label = $UILayer/UiNode/pointslabel
#@onready var spawner  = $RadialSpawner
@onready var random_spawner1 = $DirectionalSpawner
@onready var random_spawner2 = $DirectionalSpawner2
@onready var pause_menu = $PauseMenuCanvas/PauseMenu
@onready var pause_button_menu = $PauseMenuCanvas/PauseMenu/UnpauseButton
@onready var pause_button_main = $UILayer/UiNode/PauseButton
@onready var tutorial_text = $UILayer/UiNode/TutorialText
@onready var restart_button = $PauseMenuCanvas/PauseMenu/RestartButton
@onready var quit_button = $PauseMenuCanvas/PauseMenu/QuitButton

# Health canvas
@onready var health_points_canvas = $UILayer/UiNode/lives
var leaf_array = []
var lives = 4

# Spawn timer
var spawn_timer: Timer = Timer.new()
var spawn_timer_countdown: int 

# Setting up var and bools
var counting = false
var click_counter = 0
const TIME_LIMIT = 0.5
var count_timer = 0
var score = 0

var held_object = false

func _ready():
	var difficulty = Global.get_difficulty()
	if difficulty == 0:
		spawn_timer_countdown = 4
	elif difficulty == 1:
		spawn_timer_countdown = 3
	else:
		spawn_timer_countdown = 2
	Global.update_points.connect(_on_trashbin_update_points)
	Global.trash_clicked.connect(_on_pickable_clicked)
	get_leaf_arrays()
	# Setting timer countdown
	spawn_timer.wait_time = spawn_timer_countdown
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	# Setting pause menu 
	pause_menu.hide()
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_button_main.pressed.connect(_on_pause_button_main_pressed)
	pause_button_menu.pressed.connect(_on_pause_button_menu_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
func text_fade(label, delta):
	label.modulate.a += -delta * 0.3 
	
func _on_spawn_timer_timeout():
	random_spawner1.spawn_random()
	random_spawner2.spawn_random()

func _on_pause_button_main_pressed():
	pause_button_main.hide()
	get_tree().paused = true
	pause_menu.show()
	
func _on_pause_button_menu_pressed():
	pause_button_main.show()
	get_tree().paused = false
	pause_menu.hide()
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_quit_button_pressed():
	get_tree().quit()
	
func count_pickables():
	return get_tree().get_nodes_in_group("pickable").size()
	
func get_leaf_arrays():
	for leaf in health_points_canvas.get_children():
		leaf_array.append(leaf)
	
func bad_differentation():
	lives -= 1
	leaf_array[lives].self_modulate = Color(1, 0.498039, 0.313726, 1)
	
func game_over():
	Global.game_over_sound.emit()
	Global.save_high_score(score)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Scenes/gameover_menu.tscn")
	
func _process(delta):
	text_fade(tutorial_text, delta)
	if lives <= 0 or count_pickables() > 25:
		game_over()
	
# score utility
func _on_trashbin_update_points(points):
	update_score(points)
	set_points_label_text(points_label, score)
	
func set_points_label_text(label, text):
	label.text = str(score)
	
	
func update_score(points):
	if points > 0:
		score += points
	else:
		# also lose 1 live
		bad_differentation()
		
		
# pick function
func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			var impulse_size = Input.get_last_mouse_velocity()
			if held_object != null:
				held_object.drop(impulse_size)
				held_object = null
	# testing
	if event.is_action_pressed("right_click"):
		pass
		#spawner.spawn()
		#random_spawner1.spawn_random()

