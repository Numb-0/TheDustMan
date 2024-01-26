extends Area2D

@export var trash_type : String = ""

func _ready():
	body_entered.connect(_on_body_entered)
	# setting black_hole prop
	#gravity_direction = Vector2.ZERO
	#gravity_point = true
	#gravity_point_center = Vector2.ZERO
	#gravity = 1000
	#gravity_space_override = Area2D.SPACE_OVERRIDE_COMBINE_REPLACE
	# set mode for both 
	#linear_damp = 5
	linear_damp_space_override = Area2D.SPACE_OVERRIDE_COMBINE_REPLACE

func _on_body_entered(body):
	body.remove_from_held()
	body.input_pickable = false
	body.set_collision_mask_value(1, false)
	body.linear_velocity *= 0.1 
	
	if body.trash_type == trash_type:
		# signal to main script
		Global.update_points.emit(body.trash_points)
		
	Global.trash_entering_bin.emit(body)
		
	
	
	
