extends Control

# Children
@onready var money_label: Label = $AnchorTopRight/VBoxContainer/MoneyLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_money_label(money: float):
	# calculate the value
	money_label.text = "Money: " + str(money) + "$"
