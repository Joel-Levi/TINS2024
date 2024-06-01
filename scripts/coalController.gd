extends Node

var grace = 5
var current_grace = 0
var burn_duration = 1
var burn_multiplier = 1
var speed = 0
var active = false
var shovelPos = 0

var total = 10000
var current_burn_time = 0

signal game_over

@onready var debug_label = $DebugLabel
@onready var character = $AnimatedSprite2D
@onready var bg_cloud = $Control/Clouds
@onready var bg_bush = $Control/Bushes
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debug_label.text = str(total)
	
	if (bg_cloud.position.x + speed*0.015  > 127+64):
		bg_cloud.position.x = 64
	else:
		bg_cloud.position.x += speed*0.015
		
	if (bg_bush.position.x + speed*0.025  > 127+64):
		bg_bush.position.x = 64
	else:
		bg_bush.position.x += speed*0.025
	
	
	if total <= 0:
		current_grace += delta
		if current_grace > grace:
			game_over.emit()
	else:
		current_grace = 0
	
	current_burn_time += delta * burn_multiplier
	
	if current_burn_time > burn_duration && total > 0:
		current_burn_time = 0
		total -= 1
	
	if Input.is_action_just_pressed('right') && active:
		shovelPos = 1
		character.flip_h = true
		
	if Input.is_action_just_pressed("left") && shovelPos == 1 && active:
		shovelPos = 0
		character.flip_h = false
		total += 1

func enable_game(n):
	active = n == 'coal'
	if active: 
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))


func _on_driver_speed_changed(newValue):
	speed = newValue
	burn_multiplier = (1 + newValue / 20)
