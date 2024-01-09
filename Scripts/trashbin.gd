extends Area2D

var trash_type = "BIO"
var body_entering = false

func _ready():
	body_entered.connect(_on_body_entered)
	# setting black_hole prop
	gravity_direction = Vector2.ZERO
	gravity_point = true
	gravity_point_center = Vector2.ZERO
	gravity = 1000
	gravity_space_override = 2
	# set mode for both 
	linear_damp = 5
	linear_damp_space_override = 2

func _on_body_entered(body):
	Global.trash_entering_bin.emit(body)
	body.linear_velocity *= 0.1 
	#body.apply_central_impulse(body.center_of_mass)
	body.remove_from_held()
	body.input_pickable = false
	body.set_collision_mask_value(1, false)
	
	if body.trash_type == trash_type:
		# signal to main script
		Global.update_points.emit(body.trash_points)
		
	
	
	
