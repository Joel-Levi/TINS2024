extends Node

var active = true
var speed = 0

var food1 = preload("res://scenes/food1.tscn")
var food2 = preload("res://scenes/food2.tscn")

@onready var debug_label = $CenterContainer/DebugLabel
@onready var floor = $Control/floor
@onready var bg = $Control/bg
@onready var l1 = $Control/floor/l1
@onready var l2 = $Control/floor/l2
@onready var l3 = $Control/floor/l3
@onready var l4 = $Control/floor/l4
@onready var r1 = $Control/floor/r1
@onready var r2 = $Control/floor/r2
@onready var r3 = $Control/floor/r3
@onready var r4 = $Control/floor/r4

var table_positions = []

var tables = [
	[1,0],
	[1,1],
	[0,1],
	[0,0],
	[1,0],
	[1,0],
	[1,0],
	[1,0],
	[1,0],
	[1,0],
	[1,1],
	[0,0],
	[0,1],
	[1,0],
	[1,0],
	[1,0],
	[1,0],
	[1,0],
]

var currentTable = 0

var animation_speed = 10
var floor_timer = 0
var moving = false

var foods = []

func create_food():
	var food = food1.instantiate()
	floor.add_child(food)
	foods.append(food)

func create_air():
	var air = Node2D.new()
	floor.add_child(air)
	foods.append(air)
	

func next_table(offset):
	if tables[currentTable+offset][0]:
		create_food()
	else:
		create_air()
		
	if tables[currentTable+offset][1]:
		create_food()
	else:
		create_air()

func _ready():
	table_positions = [l1,r1,l2,r2,l3,r3,l4,r4]
	
	for n in 3:
		if tables[n][0]:
			create_food()
		else:
			create_air()
			
		if tables[n][1]:
			create_food()
		else:
			create_air()

func _process(delta):

	
	if (bg.position.y + speed*0.025  > 127):
		bg.position.y = 0
	else:
		bg.position.y += speed*0.025
	
	if moving:
		floor_timer += delta
		floor.position.y = 128 * min(floor_timer, 1)
		
		if floor.position.y == 64:
			moving = false
			floor_timer = 0.5
			next_table(2)
			
		if 128 * floor_timer >= 127:
			floor.position.y = 0
			floor_timer = 0
			moving = false
			
			foods.pop_front().queue_free()
			foods.pop_front().queue_free()
			
			foods.pop_front().queue_free()
			foods.pop_front().queue_free()
			next_table(2)
			
	
	var index = 0
	for food in foods:
		food.position = table_positions[index].position
		index+=1
	
	if !active: 
		return
		
	if Input.is_action_just_released('right') && !moving:
		if tables[currentTable][1] == 0:
			moving = true
			currentTable+=1
		else:
			pass
		
	if Input.is_action_just_released("left") && !moving:
		if tables[currentTable][0] == 0:
			moving = true
			currentTable+=1
		else:
			pass
			
	if Input.is_action_just_released("up") && !moving:
		if tables[currentTable][0] == 1 && tables[currentTable][1] == 1:
			moving = true
			currentTable+=1
		else:
			pass

func enable_game(n):
	active = n == 'catering'
	if active: 
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))

func _on_driver_speed_changed(newValue):
	speed = newValue
