extends Node

var kills = 0 
var level = 1
var luck = 10
var alive = true
var min_x = -1012
var max_x = 2513
var min_y = -643
var max_y = 1562
var player = null
var pausescreen = null
var diescreen = null

@onready var audio = $AudioStreamPlayer
@onready var bgm: AudioStreamPlayer = $BGMPlayer

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	if bgm:
		bgm.play()
	else:
		push_error("BGM node reference is missing on ", name)


func initialize() -> void:
	kills = 0
	level = 1
	alive = true

func _on_node_added(node: Node) -> void:
	if node.name == "Princess1":
		player = node
		if not player.died.is_connected(_on_princess_died):
			player.died.connect(_on_princess_died)
	elif node.name == "DieScreen":
		diescreen = node
	elif node.name == "PauseScreen":
		pausescreen = node

func spawn_location(p_min_x: float, p_max_x: float, p_min_y: float, p_max_y: float) -> Vector2:
	return Vector2(
		randi_range(p_min_x, p_max_x),
		randi_range(p_min_y, p_max_y)
	)

func _on_princess_died(_health: Variant) -> void:
	if bgm:
		bgm.stop()
	get_tree().paused = true
	alive = false
	
	# Fallback search if diescreen was not set yet
	if not diescreen:
		var current_scene = get_tree().current_scene
		if current_scene:
			diescreen = current_scene.get_node_or_null("Camera2D/GUI/DieScreen")

	# Show death screen and populate text directly
	if diescreen and diescreen.has_method("show_death_screen"):
		diescreen.show_death_screen()
