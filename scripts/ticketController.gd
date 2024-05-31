extends Node

var ticketScene = preload("res://scenes/ticket.tscn")

var active = true
var gameover = false
var tickets = [ false,false,true,true,false,true,false ]
var currentTicket

var newTicketTime = 5
var currentTicketTime = 0
var rng

@onready var debug_label = $CenterContainer/DebugLabel

func _ready():
	rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameover: 
		return

	currentTicketTime += delta
	
	if currentTicketTime > newTicketTime:
		currentTicketTime = 0
		if rng.randi_range(0,1) == 1:
			tickets.append(true)
		else:
			tickets.append(false)

	if currentTicket == null:
		generate_ticket(tickets[0])

	debug_label.text = str(tickets.size())

	if !active: 
		return
		
	if Input.is_action_just_released('right'):
		if tickets[0] == true:
			currentTicket.queue_free()
			tickets.pop_front()
		else:
			debug_label.text = 'FACKED'
			gameover = true
		
	if Input.is_action_just_released("left"):
		if tickets[0] == false:
			currentTicket.queue_free()
			tickets.pop_front()
		else:
			debug_label.text = 'FACKED'
			gameover = true
	


func enable_game(n):
	active = n == 'tickets'
	if active: 
		debug_label.add_theme_color_override("font_color", Color(1.0,0.0,0.0,1.0))
	else:
		debug_label.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))

func generate_ticket(valid):
	var ticket = ticketScene.instantiate()
	add_child(ticket)
	ticket.set_label_text(str(valid))
	ticket.position.x = 0
	ticket.position.y = 40
	currentTicket = ticket
