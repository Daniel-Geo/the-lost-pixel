extends Node2D

var score = 0
var has_key = false

@onready var score_label: Label = $"../Player/ScoreLabel"

func add_point():
	score += 1
	score_label.text = "Coins x" + str(score)
	
