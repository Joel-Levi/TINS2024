extends Node

var active = false
var speed = 0
@onready var debug_label = $CenterContainer/DebugLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !active: 
		return
	if Input.is_action_pressed('ui_right') && speed < 100:
		speed += 1
		
	if Input.is_action_pressed("ui_left") && speed > 1:
		speed -= 1
	
	debug_label.text = str(speed)

func enable_game(n):
	active = n == 'conductor'
	if active: 
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))
