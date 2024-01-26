extends Area2D

@onready var bin_sprite = $AnimatedSprite2D
@onready var bin_sound_positive = $PositiveSound
@onready var bin_sound_negative = $NegativeSound

@export var trash_type : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	bin_sprite.play("Fill")
	body.linear_velocity *= 0.1 
	#body.apply_central_impulse(body.center_of_mass)
	body.remove_from_held()
	body.input_pickable = false
	body.set_collision_mask_value(1, false)
	
	if body.trash_type == trash_type:
		# signal to main script
		bin_sound_positive.play()
		Global.update_points.emit(body.trash_points)
	else:
		# we use negative point to make the game know it was a bad differentiation
		Global.update_points.emit(-1 * body.trash_points)
		bin_sound_negative.play()
		
	Global.trash_entering_bin.emit(body)
