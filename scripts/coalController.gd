extends Node

var burn_duration = 1
var burn_multiplier = 1

var active = false
var shovelPos = 0

var total = 10
var current_burn_time = 0

@onready var debug_label = $DebugLabel
@onready var character = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	current_burn_time += delta
	
	if current_burn_time > burn_duration * burn_multiplier:
		current_burn_time = 0
		total -= 1
	
	debug_label.text = str(total)
	
	if !active: 
		return
		
	if Input.is_action_pressed('right'):
		shovelPos = 1
		character.flip_h = true
		
	if Input.is_action_pressed("left") && shovelPos == 1:
		shovelPos = 0
		character.flip_h = false
		total += 1

func enable_game(n):
	active = n == 'coal'
	if active: 
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))
