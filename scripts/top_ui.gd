extends TextureRect

@onready var score_label = $MarginContainer/HBoxContainer/score_label
@onready var counter_label = $MarginContainer/HBoxContainer/counter_label
@onready var type_label = $MarginContainer/HBoxContainer/type_game

var current_score = 0
var current_moves = 16
var current_timer = 61
var current_streak = 1
var current_pieces = 0

signal times_up
signal won

func _ready():
	var game_logic = get_parent().get_node("grid")
	game_logic.connect("update_score", _on_update_score)
	game_logic.connect("update_moves", _on_update_moves)
	game_logic.connect("timeout", _on_timer_timeout)

func setStreak(streak):
	current_streak = streak
	print(current_streak)
	
func setPieces(pieces):
	current_pieces = pieces
	print(current_pieces)

func _on_update_score():
	print("Actualizando puntaje")
	current_score += 10 * current_pieces * current_streak  # Increment the score by 10 when tiles match
	score_label.text = "Score:" + str(current_score) 	
	
func _on_update_moves():
	print("Actualizando movimientos")
	current_moves -= 1  # Decrement the score by 1 when tiles match
	counter_label.text = str(current_moves) 
	type_label.text = "BY MOVES" 
	
	if current_moves <= 0 and current_score < 1000:
		print("No tienes más movimientos")
		emit_signal("times_up")
	elif current_score >= 1000:
		print("Ganaste")
		current_moves = 16
		emit_signal("won")
		
func _on_timer_timeout():
	current_timer -= 1
	counter_label.text = str(current_timer) 
	type_label.text = "BY TIME" 

	if current_timer <= 0:
		print("Se acabo el tiempo")
		emit_signal("times_up")
