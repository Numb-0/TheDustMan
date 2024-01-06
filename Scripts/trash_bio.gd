extends "res://Scripts/trash.gd"

func _ready():
	# calling base class _ready() 
	super._ready()
	trash_points = 10
	trash_type = "BIO"
	Global.test.connect(do_test_connect)

func do_test_connect(object, arg1):
	# we know the sender and we can also pass some variable
	print(str(object) + "sended variable: " + str(arg1))
