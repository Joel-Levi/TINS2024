extends Node

var shovelPos = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('ui_right'):
		shovelPos = 1
		
	if Input.is_action_pressed("ui_left"):
		shovelPos = 0
		
