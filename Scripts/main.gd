extends Node2D

# loading resources
var trash_scene = preload("res://Scenes/trash_bio.tscn")
@onready var points_label = $pointslabel

# Setting up var and bools
var counting = false
var click_counter = 0
const TIME_LIMIT = 0.5
var count_timer = 0
var score = 0

var held_object = false

func _ready():
	get_node("trashbin").update_points.connect(_on_trashbin_update_points)
	# i will need to run this every time i add a new object?
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)
		

func _on_trashbin_update_points(points):
	update_score(points)
	set_points_label_text(points_label, score)
		
		
func _on_pickable_clicked(object):
	if !held_object:
		object.pickup()
		held_object = object


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity() / 5.0)
			held_object = null
			
func _process(_delta):
	pass
	
func spawn_trash():
	var trash_istance = trash_scene.instantiate()
	trash_istance.position = Vector2()
	add_child(trash_istance)
	
	
func set_points_label_text(label, text):
	label.text = "Points: " + str(score)
	
	
func update_score(points):
	score += points
	

	
