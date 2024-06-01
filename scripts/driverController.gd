extends Node

signal speed_changed(newValue)
signal game_over

var active = false
var current_speed = 0
var target_speeds = [
	[0, 0],
	[1000, 0],
	[1001, 0],
]

var current_time = 0
var current_target_speed = 0

var invalid_timer = 0
var invalid_timer_limit = 60
var range = 5

var moving_timer = 0
var speed_mod = 1

@onready var shaft = $Shaft
@onready var debug_label = $DebugLabel
@onready var target_label = $TargetSpeed

func _ready():
	current_target_speed = target_speeds[0][1]
	target_speeds.pop_front()
	target_label.text = str(current_target_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debug_label.text = str(current_speed)
	
	shaft.rotation = remap(current_speed, 0, 100, -.75, .75)
	
	current_time += delta
	
	if target_speeds[0][0] < current_time:
		current_target_speed = target_speeds[0][1]
		target_speeds.pop_front()
		target_label.text = str(current_target_speed)
	
	var current_diff =  (current_speed - current_target_speed)
	
	if current_diff > range || current_diff < range*-1:
		invalid_timer += delta
		target_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		invalid_timer = 0
		target_label.add_theme_color_override("font_color", Color(0.0,1.0,0.0,1.0))
	
	if invalid_timer > invalid_timer_limit:
		game_over.emit()
	
	if !active: 
		return
		
	if Input.is_action_pressed('right') && current_speed < 100:
		moving_timer+= delta
		speed_mod = 1
		
	if Input.is_action_pressed("left") && current_speed > 1:
		moving_timer+= delta
		speed_mod = -1
	
	if Input.is_action_pressed("left") && Input.is_action_pressed("right"):
		speed_mod = 0
		moving_timer = 0
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right"):
		speed_mod = 0
		moving_timer = 0
	
	
	if current_speed >= 0 && current_speed <= 100:
		current_speed += int(round(3.0 * moving_timer * moving_timer)) * speed_mod
		current_speed = clamp(0, current_speed, 100)
	
	#if current_speed % 10:
	speed_changed.emit(current_speed)

func enable_game(n):
	active = n == 'driver'
	if active: 
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))
