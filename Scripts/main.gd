extends Node2D

# loading resources
var trash_scene = preload("res://Scenes/trash_bio.tscn")
@onready var points_label = $pointslabel
@onready var spawner  = $RadialSpawner

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
	
	
# score utility
func _on_trashbin_update_points(points):
	update_score(points)
	set_points_label_text(points_label, score)
	
func set_points_label_text(label, text):
	label.text = "Points: " + str(score)
	
	
func update_score(points):
	score += points
		
		
# pick function
func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			var impulse_size = Input.get_last_mouse_velocity()
			held_object.drop(impulse_size)
			held_object = null
	# testing
	if event.is_action_pressed("right_click"):
		spawner.spawn()
