extends Node

signal level_complete
signal game_over

const games = [ 'catering', 'driver', 'coal', 'tickets' ]
var currentGame = 0;
var level = {
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

func get_level():
	return level
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("switch"):
		currentGame+=1
		
		if currentGame >= games.size():
			currentGame = 0
		
		get_tree().call_group('games', 'enable_game', games[currentGame])

func _on_coal_game_over():
	reasonText='You ran out of coal'
	game_over_function()

func _on_driver_game_over():
	reasonText='You failed to match the target speed'
	game_over_function()
	
func _on_tickets_game_over():
	reasonText='You failed to many ticket validations'
	game_over_function()

# AAAAH LAST MINUTE
@onready var tickets = $Tickets
@onready var catering = $Catering

func _on_driver_trip_done():
	if !tickets.get_done(): 
		reasonText='You did not validate all the tickets'
		game_over_function()
		return
	if !catering.get_done(): 
		reasonText='You did not do all the catering'
		game_over_function()
		return
		
	reasonText = 'YOU WIN'
	game_over_function()

func game_over_function():
	reason.text = reasonText
	game_over_rect.visible = true

var reasonText = ''

@onready var reason = $ColorRect2/REASON
@onready var game_over_rect = $ColorRect2

@onready var frame = $Frame
func _on_catering_activated(pos):
	frame.position = pos

func _on_tickets_activated(pos):
	frame.position = pos

func _on_coal_activated(pos):
	frame.position = pos

func _on_driver_activated(pos):
	frame.position = pos



func _on_button_pressed():
	game_over.emit()
	queue_free()
