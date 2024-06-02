extends Node

var grace = 5
var current_grace = 0
var burn_duration = 1
var burn_multiplier = 1
var speed = 0
var active = false
var shovelPos = 0

var total = 10
var current_burn_time = 0

signal game_over
signal activated
@onready var warning = $warning
@onready var character = $AnimatedSprite2D
@onready var bg_cloud = $Control/Clouds
@onready var fire = $Fire
@onready var bg_bush = $Control/Bushes
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	warning.visible = total < 20
	
	if total > 0:
		warning.text = 'LOW COAL'
	else:
		warning.text = 'NO COAL'
	
	if (bg_cloud.position.x + speed*0.015  > 127+64):
		bg_cloud.position.x = 64
	else:
		bg_cloud.position.x += speed*0.015
		
	if (bg_bush.position.x + speed*0.025  > 127+64):
		bg_bush.position.x = 64
	else:
		bg_bush.position.x += speed*0.025
	
	
	if total <= 0:
		current_grace += delta
		if current_grace > grace:
			game_over.emit()
	else:
		current_grace = 0
	
	current_burn_time += delta * burn_multiplier
	
	if current_burn_time > burn_duration && total > 0:
		current_burn_time = 0
		total -= 1
	
	if Input.is_action_just_pressed('right') && active && !character.is_playing():
		shovelPos = 1
		character.play('right')
		
	if Input.is_action_just_pressed("left") && shovelPos == 1 && active && !character.is_playing():
		shovelPos = 0
		character.play('left')
		total += 10

	if fire.animation != 'empty' && total <= 10:
		fire.play('empty')
	if fire.animation != 'small' && total > 10 && total <= 40:
		fire.play('small')
	if fire.animation != 'big' && total > 40:
		fire.play('big')

func enable_game(n):
	active = n == 'coal'
	if active: 
		activated.emit(self.position)

func _on_driver_speed_changed(newValue):
	speed = newValue
	burn_multiplier = (1 + newValue / 20)
