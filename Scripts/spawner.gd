extends Marker2D

signal spawned(spawn)

@export var spawn_object_scene : PackedScene

func spawn():
	var spawn_object = spawn_object_scene.instantiate()
	add_child(spawn_object)
	#spawn_object.set_as_toplevel(true)
	spawn_object.global_position = global_position
	spawned.emit(spawn_object)
	return spawn_object
