extends Node2D
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

func _on_level_1_pressed():
	var g = game.instantiate()
	controls.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(g)
	g.game_over.connect(enableControls)

func _on_level_2_pressed():
	var g = game.instantiate()
	controls.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(g)
	g.game_over.connect(enableControls)
	

func _on_level_3_pressed():
	var g = game.instantiate()
	controls.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(g)
	g.game_over.connect(enableControls)
	
