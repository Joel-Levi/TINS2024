extends Node

var ticketScene = preload("res://scenes/ticket.tscn")

var active = true
var gameover = false
var tickets = [ false,false,true,true,false,true,false ]
var currentTicket

var newTicketTime = 5
var currentTicketTime = 0
var rng
var noise

@onready var debug_label = $DebugLabel

func _ready():
	rng = RandomNumberGenerator.new()
	noise = FastNoiseLite.new()

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
	else:
		if rng.randi_range(0,5) == 1:
			currentTicket.position.x = 0
			currentTicket.position.x = sway(currentTicket.position.x)
		if rng.randi_range(0,10) == 1:
			currentTicket.position.y = 0
			currentTicket.position.y = sway(currentTicket.position.y)
	
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
	ticket.position.y = 15
	currentTicket = ticket
	
	

var sway_magnitude = 3
var sway_timer = 0
var sway_period = 20
	
func sway(start):
	var displacement = sway_magnitude * sin(sway_timer / rng.randf_range(sway_period, 20))
	var v = start + displacement
	sway_timer += 1
	return v
