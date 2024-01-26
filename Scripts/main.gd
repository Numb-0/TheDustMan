extends Node2D

# loading resources
@onready var points_label = $UILayer/UiNode/pointslabel
@onready var spawner  = $RadialSpawner
@onready var random_spawner1 = $DirectionalSpawner

@onready var health_points_canvas = $UILayer/UiNode/lives
var leaf_array = []
var lives = 4

# Setting up var and bools
var counting = false
var click_counter = 0
const TIME_LIMIT = 0.5
var count_timer = 0
var score = 0

var held_object = false

func _ready():
	Global.update_points.connect(_on_trashbin_update_points)
	Global.trash_clicked.connect(_on_pickable_clicked)
	get_leaf_arrays()
	
func get_leaf_arrays():
	for leaf in health_points_canvas.get_children():
		leaf_array.append(leaf)
	
func bad_differentation():
	lives -= 1
	if lives > 0:
		leaf_array[lives].self_modulate = Color(1, 0.498039, 0.313726, 1)
	else:
		leaf_array[lives].self_modulate = Color(1, 0.498039, 0.313726, 1)
		Global.save_high_score(score)
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
	
# score utility
func _on_trashbin_update_points(points):
	update_score(points)
	set_points_label_text(points_label, score)
	
func set_points_label_text(label, text):
	label.text = "Points: " + str(score)
	
	
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
		#spawner.spawn()
		random_spawner1.spawn_random()

