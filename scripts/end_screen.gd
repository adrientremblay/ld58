extends Panel

# Children
@onready var end_game_label: Label = $VBoxContainer/EndGameLabel
@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready() -> void:
	if Global.survived:
		end_game_label.text = "You escaped the graveyard with your stolen loot"
	
	score_label.text = "You stole "+str(Global.score)+"$ worth of artifacts"
