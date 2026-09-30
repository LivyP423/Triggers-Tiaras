extends Control

@onready var kill_label: Label = $Label



func _ready() -> void:
	#kill_label.text = str(gamemaster.kills) 
	pass
	
func _process(delta: float) -> void:
	kill_label.text = str(gamemaster1.kills) 


func add_kill(new_count: int) -> void:
	kill_label.text = str(new_count)
