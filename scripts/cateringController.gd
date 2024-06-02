extends Node

signal activated

var active = false
var speed = 0
var done = false
var food1 = preload("res://scenes/food1.tscn")
var food2 = preload("res://scenes/food2.tscn")
@onready var doneLabel = $DoneLabel
@onready var audio = $bg
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
@onready var foodSpawn = $Control/FoodSpawn
@onready var interactionAudio = $Interaction
@onready var trolleyAudio = $Trolley
var table_positions = []

var tables

var currentTable = 0

var animation_speed = 10
var floor_timer = 0
var moving = false

var foods = []

func get_done():
	return done

func create_food():
	var food = food1.instantiate()
	floor.add_child(food)
	foods.append(food)

func create_air():
	var air = Node2D.new()
	floor.add_child(air)
	foods.append(air)
	

func next_table(offset):
	if tables.size() == currentTable + 2:
		done = true
		return 
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
	
	var game = get_parent()
	tables = game.get_level().catering
	
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
		
	if doneLabel.visible == false && done:
		doneLabel.visible = true
		return
		
	if done:
		return
	
	if Input.is_action_just_released('right') && !moving && active:
		if tables[currentTable][1] == 0:
			interactionAudio.play()
			tables[currentTable][1] = 1 
			
			var food = food1.instantiate()
			floor.add_child(food)
			if currentTable%2:
				foods[3] = food
			else:
				foods[1] = food
		else:
			pass
		
	if Input.is_action_just_released("left") && !moving && active:
		if tables[currentTable][0] == 0:
			interactionAudio.play()
			tables[currentTable][0] = 1
			var food = food1.instantiate()
			floor.add_child(food)
			if currentTable%2:
				foods[2] = food
			else:
				foods[0] = food
		else:
			pass
			
	if Input.is_action_just_released("up") && !moving && active:
		if tables[currentTable][0] == 1 && tables[currentTable][1] == 1:
			moving = true
			currentTable+=1
			trolleyAudio.play()
			
			
		else:
			pass
	

	
	if moving:
		floor_timer += delta*2
		floor_timer = min(floor_timer, 1)
		
		if floor_timer != 1 && currentTable%2 != 0:
			floor.position.y = 64 * floor_timer
		
		if floor_timer != 1 && currentTable%2 == 0:
			floor.position.y = 64+ 64 * floor_timer
		
		if floor_timer == 1 && currentTable%2 != 0:
			moving = false
			floor_timer = 0
			next_table(2)
		
		if floor_timer == 1 && currentTable%2 == 0:
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
		
	

func enable_game(n):
	active = n == 'catering'
	if active: 
		audio.play()
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
		activated.emit(self.position)
	else:
		audio.stop()
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))

func _on_driver_speed_changed(newValue):
	speed = newValue
