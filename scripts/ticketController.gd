extends Node

var ticketScene = preload("res://scenes/ticket.tscn")

@onready var bon = $Bon
@onready var non = $Non
@onready var zut = $Zut

@onready var date = $date

signal game_over
signal activated

var lives = 3

var active = false
var gameover = false
var tickets
var currentTicket
var changeTicket = true

var rng

var handDown = false
var handSpeed = 5
var handTime = .6

@onready var debug_label = $DebugLabel

var currentHandAnimationTimer = 0

func _ready():
	var game = get_parent()
	tickets = game.get_level().tickets
	
	rng = RandomNumberGenerator.new()
	generate_ticket(tickets[0])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameover: 
		return
	
	date.text = current_date
	lives_label.text = str(lives)
	animateHand(delta)



	if !active || handDown: 
		return
		
	if Input.is_action_just_released('right') == true:
		if tickets[0] == true:
			correct()
			bon.play()
		else:
			incorrect()
			
	if Input.is_action_just_released("left"):
		if tickets[0] == false:
			non.play()
			correct()
		else:
			incorrect()

func correct():
	handDown = true

@onready var lives_label = $lives

func incorrect():
	zut.play()
	lives -= 1

	if lives == 0:
		game_over.emit()

@onready var done = $Done


func get_done():
	return currentTicket == null
	
func animateHand(delta):
	if currentTicket == null:
		done.visible = true
		return
		
	if handDown:
		currentHandAnimationTimer+= delta
		
		if currentHandAnimationTimer < handTime:
			currentTicket.rotation -=handSpeed*delta
		
		if currentHandAnimationTimer > handTime:
			if changeTicket:
				changeTicket = false
				tickets.pop_front()
				if tickets.size() == 0:
					currentTicket.queue_free()
					return
				else:
					currentTicket.set_label_text(generate_ticket_text(tickets[0]))
			
			if (currentTicket.rotation + handSpeed*delta > .1):
				handDown = false
				currentHandAnimationTimer = 0
				changeTicket = true
			else:
				currentTicket.rotation +=handSpeed*delta
		
	if rng.randi_range(0,5) == 1:
		currentTicket.position.x = 94
		currentTicket.position.x = sway(currentTicket.position.x)
	if rng.randi_range(0,10) == 1:
		currentTicket.position.y = 137
		currentTicket.position.y = sway(currentTicket.position.y)

func enable_game(n):
	active = n == 'tickets'
	if active:
		activated.emit(self.position)

@onready var control = $TicketContainer

func generate_ticket(valid):
	var ticket = ticketScene.instantiate()
	control.add_child(ticket)
	ticket.set_label_text(generate_ticket_text(valid))
	ticket.position.x = 94
	ticket.position.y = 137
	currentTicket = ticket

var sway_magnitude = 3
var sway_timer = 0
var sway_period = 20
	
func sway(start):
	var displacement = sway_magnitude * sin(sway_timer / rng.randf_range(sway_period, 20))
	var v = start + displacement
	sway_timer += 1
	return v

var current_date = '2-5'
var current_month = 5
var months =  [
'Jan',
'Fév',
'Mars',
'Avr',
'Mai',
'Juin',
'Juil',
'Août',
'Sept',
'Oct',
'Nov',
'Déc'
]

func generate_ticket_text(valid):
	if valid:
		var type = rng.randi_range(1,2)
		if type == 2:
			return months[current_month-1]
		if type == 1:
			return current_date
	else:
		var type = rng.randi_range(1,2)
		if type == 2:
			var month = rng.randi_range(0,11)
			while month == current_month:
				month = rng.randi_range(0,11)
			
			return months[month-1]
			
		if type == 1:
			var date = str(rng.randi_range(1,31)) + '-' + str(rng.randi_range(0,11))
			while date == current_date:
				date = rng.randi_range(1,11)
			
			return date
