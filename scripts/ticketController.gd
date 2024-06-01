extends Node

var ticketScene = preload("res://scenes/ticket.tscn")
@onready var check = $checkmark
@onready var cross = $cross
signal game_over

var active = false
var gameover = false
var tickets = [ false,false,true,true,false,true,false ]
var currentTicket
var changeTicket = true

var rng
var noise

var handDown = false
var handSpeed = 5
var handTime = .6

@onready var debug_label = $DebugLabel

var currentHandAnimationTimer = 0

func _ready():
	rng = RandomNumberGenerator.new()
	noise = FastNoiseLite.new()
	generate_ticket(tickets[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameover: 
		return
	
	animateHand(delta)
	
	if check.modulate.a >= 0:
		check.modulate.a -= (1+delta) * 5
		
	if cross.modulate.a >= 0:
		cross.modulate.a -= (1+delta) * 5


	if !active || handDown: 
		return
		
	if Input.is_action_just_released('right') == true:
		if tickets[0] == true:
			correct()
		else:
			incorrect()
			
	if Input.is_action_just_released("left"):
		if tickets[0] == false:
			correct()
		else:
			incorrect()

func correct():
	check.modulate.a = 255
	handDown = true

func incorrect():
	game_over.emit()
	cross.modulate.a = 255

func animateHand(delta):
	if handDown:
		currentHandAnimationTimer+= delta
		
		if currentHandAnimationTimer < handTime:
			currentTicket.rotation -=handSpeed*delta
		
		if currentHandAnimationTimer > handTime:
			if changeTicket:
				changeTicket = false
				tickets.pop_front()
				currentTicket.set_label_text(str(tickets[0]))
			
			if (currentTicket.rotation + handSpeed*delta > .1):
				handDown = false
				currentHandAnimationTimer = 0
				changeTicket = true
			else:
				currentTicket.rotation +=handSpeed*delta
		
	if rng.randi_range(0,5) == 1:
		currentTicket.position.x = 30
		currentTicket.position.x = sway(currentTicket.position.x)
	if rng.randi_range(0,10) == 1:
		currentTicket.position.y = 73
		currentTicket.position.y = sway(currentTicket.position.y)

func enable_game(n):
	active = n == 'tickets'

func generate_ticket(valid):
	var ticket = ticketScene.instantiate()
	add_child(ticket)
	ticket.set_label_text(str(valid))
	ticket.position.x = 30
	ticket.position.y = 73
	currentTicket = ticket

var sway_magnitude = 3
var sway_timer = 0
var sway_period = 20
	
func sway(start):
	var displacement = sway_magnitude * sin(sway_timer / rng.randf_range(sway_period, 20))
	var v = start + displacement
	sway_timer += 1
	return v
