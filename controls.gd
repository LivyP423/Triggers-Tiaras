extends Control

func _ready() -> void:
	visible = true
	await get_tree().create_timer(6.7).timeout
	visible = false
