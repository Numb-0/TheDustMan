extends Marker2D

signal spawned(spawn)

var spawnable_path = "res://Scenes/Spawnable/"
var spawnable_array = []

@export var spawn_direction : Vector2

func _ready():
	load_scenes()
	
func load_scenes():
	var dir = DirAccess.open(spawnable_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			#print(file_name)
			# Check if the file is a scene file
			if file_name.ends_with("tscn"):
				# Load the scene
				var scene = load(spawnable_path + file_name)
				# Add the scene to the array
				spawnable_array.append(scene)
			# Go to the next one
			file_name = dir.get_next()
		# Close dir
		dir.list_dir_end()

func spawn_random():
	var index = randi_range(0, len(spawnable_array)-1)
	var spawn_object = spawnable_array[index].instantiate()
	add_child(spawn_object)
	spawn_object.global_position = global_position
	spawn_object.apply_central_impulse(spawn_direction)
	spawned.emit(spawn_object)
	
