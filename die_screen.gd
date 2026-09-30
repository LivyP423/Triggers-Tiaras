extends Control

@onready var scoreshower = $Label2
@onready var levelshower = $Label3
@onready var deathsound = $diesound
@onready var label4 = $Label4 # RETRY?
@onready var label5 = $Label5 # PRESS START!

var can_restart: bool = false # Prevents restarting early

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Run even when game is paused
	hide()

# Called by gamemaster1 
func show_death_screen() -> void:
	can_restart = false
	label4.hide()
	label5.hide()
	
	scoreshower.text = "YOUR SCORE: " + str(gamemaster1.kills)
	levelshower.text = "YOUR LEVEL: " + str(gamemaster1.level)
	
	show()
	deathsound.play() # Plays when the screen pops up
	
	# Wait for death audio to finish before revealing the retry text
	await deathsound.finished
	label4.show()
	label5.show()
	can_restart = true # Player can now press start

func _input(event: InputEvent) -> void:
	# Only respond when death screen is visible and after the sound completes
	if visible and can_restart:
		if event.is_action_pressed("start"):
			get_tree().paused = false # Unpause the game tree
			gamemaster1.initialize()  # Reset kills, level, alive
			get_tree().reload_current_scene() # Reload scene
