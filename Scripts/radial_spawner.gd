extends "res://Scripts/spawner.gd"

@export var spawn_radius : float = 100

func spawn():
	var spawned_object = super.spawn()
	# offsetting radius
	var radial_offeset = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	# offsetting distance from center
	radial_offeset *= randf_range(0.0, spawn_radius)
	# setting object position
	spawned_object.global_position += radial_offeset 
	spawned_object.rotate(randf_range(0, TAU))
	return spawned_object
