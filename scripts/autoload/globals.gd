extends Node

signal score_changed(score : int)

enum DamageGroups {PLAYER=2, SKELETONS=4, ENEMIES=8}

var player : Player
var score : int:
	set(v):
		score = max(0, v)
		score_changed.emit(score)

var debug_message : String
