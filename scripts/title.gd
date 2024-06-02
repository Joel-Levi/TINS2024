extends Node2D
var level1 = {
	'level': 1,
	'catering':[
	[1,0],
	[1,0],
	[0,0],
	[0,0],
	[1,1],
	[1,1],
	[1,0],
	[0,0],
	[1,1],
	[1,1],
	[1,1],
],
	'target_speeds': [
		[0, 0],
		[10, 50],
		[35, 90],
		[60, 0],
],
	'tickets': [false,false,false,false,true,true]
}
var level2 = {
	'level': 2,
	'catering':[
	[0,0],
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
	[1,1],
	[1,1],
	[1,1],
	[1,1],
	[1,1],
],
	'target_speeds': [
		[0, 0],
		[10, 40],
		[30, 80],
		[50, 30],
		[70, 100],
		[80, 0],
],
	'tickets': [true,false,true,false,false,true,false]
}

var level3 = {
	'level': 3,
	'catering':[
	[1,0],
	[1,0],
	[0,1],
	[0,1],
	[0,0],
	[0,0],
	[0,0],
	[1,1],
	[1,1],
	[1,0],
	[0,1],
	[0,1],
	[0,0],
	[1,0],
	[0,1],
	[1,0],
	[0,0],
	[1,1],
	[0,1],
	[0,1],
	[0,0],
	[0,0],
	[1,1],
	[1,1],
	[1,1],
],
	'target_speeds': [
		[0, 0],
		[10, 100],
		[20, 10],
		[35, 100],
		[55, 0],
		[70, 100],
		[80, 50],
		[90, 20],
		[100, 0],
],
	'tickets': [true,false,false,true,false,false,true,true,false,false,true,false,false,true,false]
}


var game = preload("res://scenes/game.tscn")
@onready var controls = $Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func enableControls():
	controls.process_mode = Node.PROCESS_MODE_ALWAYS
@onready var l1 = $"Control/VBoxContainer/Level 1"
@onready var l2 = $"Control/VBoxContainer/Level 2"
@onready var l3 = $"Control/VBoxContainer/Level 3"
func won(level):
	if level == 1:
		l1.text = l1.text + ' (COMPLETED)'
	if level == 2:
		l2.text = l2.text + ' (COMPLETED)'
	if level == 3:
		l3.text = l3.text + ' (COMPLETED)'

func _on_level_1_pressed():
	var g = game.instantiate()
	g.level = level1
	controls.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(g)
	g.game_over.connect(enableControls)
	g.won.connect(won)

func _on_level_2_pressed():
	var g = game.instantiate()
	g.level=level2	
	controls.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(g)
	g.game_over.connect(enableControls)
	

func _on_level_3_pressed():
	var g = game.instantiate()
	g.level=level3
	controls.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(g)
	g.game_over.connect(enableControls)
	
