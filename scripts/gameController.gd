extends Node
@onready var conductor = $"../Conductor"
@onready var coal = $"../Coal"

const games = [ 'coal', 'conductor', 'catering', 'tickets' ]
var currentGame = 0;
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
