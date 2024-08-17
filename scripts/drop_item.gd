extends Node

@export_range(0,1) var drop_rate : float = 1

func drop_item():
	if randf() < drop_rate:
		GlobalEvents.item_dropped.emit(owner.position)
