extends RigidBody2D

@export var trash_type : String = ""
@export var trash_points : int = 0

@onready var trash_sprite = $Sprite2D

signal clicked(object)
var held = false
var calculated_drag_offset = false
var offset = 0
var entering_bin = false

var death_timer = Timer.new()

func _ready():
	add_to_group("pickable")
	self.input_event.connect(_on_input_event)
	Global.trash_entering_bin.connect(_on_entering_bin)
	# setting timer parameters
	add_child(death_timer)
	death_timer.wait_time = 2
	death_timer.one_shot = true
	death_timer.timeout.connect(_on_death_timer_end)
	
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked")
		if event.pressed:
			clicked.emit(self)
		
func _on_entering_bin(body):
	body.entering_bin = true
	
		
func _physics_process(delta):
	if held:
		if not calculated_drag_offset:
			offset = global_transform.origin - get_global_mouse_position()
			print(offset)
			calculated_drag_offset = true
		global_transform.origin = get_global_mouse_position() + offset
	if entering_bin:
		fade_off_shrink(delta)
		
		
func pickup():
	if held:
		return
	freeze = true
	held = true


func drop(impulse = Vector2.ZERO):
	if held:
		freeze = false
		apply_central_impulse(impulse)
		held = false
		calculated_drag_offset = false
		
		
func fade_off_shrink(delta):
	death_timer.start()
	print(self.scale)
	trash_sprite.scale += 3*Vector2(-delta,  -delta)
	trash_sprite.modulate.a8 += - delta * 100
	self.angular_velocity = 5
	# it works lol
	#await get_tree().create_timer(1).timeout
	#queue_free()

func _on_death_timer_end():
	queue_free()
