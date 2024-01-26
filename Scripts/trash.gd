extends RigidBody2D

@export var trash_type : String = ""
@export var trash_points : int = 0

@onready var trash_sprite = $Sprite2D
const smoke_effect = preload("res://Scenes/smoke_effect.tscn")
#@onready var trash_shape = $CollisionPolygon2D

var held = false
var calculated_drag_offset = false
var offset = 0
var entering_bin = false
var death_timer = Timer.new()


func _ready():
	add_to_group("pickable")
	input_event.connect(_on_input_event)
	Global.trash_entering_bin.connect(_on_entering_bin)
	linear_damp = 1
	# setting timer parameters
	add_child(death_timer)
	death_timer.wait_time = 0.1
	death_timer.one_shot = true
	death_timer.timeout.connect(_on_death_timer_end)


func _on_death_timer_end():
	# after x time kill entity
	queue_free()
	
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			Global.trash_clicked.emit(self)
		
		
func _on_entering_bin(body):
	var smoke_particle_effect = smoke_effect.instantiate()
	#smoke_particle_effect.position = position
	body.add_child(smoke_particle_effect)
	body.death_timer.start()
	#body.entering_bin = true
	# we start the timer here since we need to call it once
	#body.death_timer.start()
	
		
func _physics_process(_delta):
	if held:
		if not calculated_drag_offset:
			offset = global_transform.origin - get_global_mouse_position()
			calculated_drag_offset = true
		global_transform.origin = get_global_mouse_position() + offset
	#if entering_bin:
	#	fade_off_shrink(delta)
		
		
func pickup():
	if held:
		return
	freeze = true
	held = true


func drop(impulse = Vector2.ZERO):
	if held:
		freeze = false
		apply_central_impulse(impulse)
		# scaling velocity to not bug collision detection
		linear_velocity *= 0.7
		held = false
		calculated_drag_offset = false
		
		
func remove_from_held():
	if held:
		#freeze = false
		held = false
		calculated_drag_offset = false
		
		
func fade_off_shrink(delta):
	trash_sprite.scale += 3 * -Vector2(delta, delta)
	trash_sprite.modulate.a8 += -delta * 100
	angular_velocity = 5
	# it works lol

