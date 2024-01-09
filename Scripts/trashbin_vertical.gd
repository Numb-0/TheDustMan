extends Area2D

signal update_points(points)
signal update_health

var trash_type
var body_entering = false
var destination_point = position + Vector2(0, 150)

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	Global.trash_entering_bin.emit(body)
	body.linear_velocity = Vector2.ZERO
	
	# disconnecting the signal so the user can't manipulate the body after contact
	var dict = body.clicked.get_connections()
	body.clicked.disconnect(dict[0]["callable"])
	body.drop()
	
	if body.trash_type == trash_type:
		# signal to main script
		Global.test.emit(self, 7)
		update_points.emit(body.trash_points)

func move_trash_in_bin(body):
	var force_direction = destination_point - body.center_of_mass
	body.apply_central_force(force_direction*100)
	
