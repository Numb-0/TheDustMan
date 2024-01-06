extends Area2D

signal update_points(points)
signal update_health

var trash_type = "BIO"
var body_entering = false

func _ready():
	self.body_entered.connect(_on_body_entered)
	# setting black_hole prop
	self.gravity_direction = Vector2.ZERO
	self.gravity_point = true
	# do not set gravity point center!!
	self.gravity = 1000
	self.gravity_space_override = 2
	# set mode for both 
	self.linear_damp = 10
	self.linear_damp_space_override = 2
	


func _process(delta):
	pass

func _on_body_entered(body):
	Global.trash_entering_bin.emit(body)
	body.linear_velocity = Vector2.ZERO
	if body.trash_type == trash_type:
		# signal to main script
		Global.test.emit(self, 7)
		update_points.emit(body.trash_points)
		
	
	
	
