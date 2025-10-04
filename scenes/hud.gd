extends Control

# Children
@onready var money_label: Label = $AnchorTopRight/VBoxContainer/MoneyLabel
@onready var artifact_panel: PanelContainer = $ArtifactPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_money_label(money: float):
	# calculate the value
	money_label.text = "Money: " + str(money) + "$"

func _on_grave_move_artifact_label_to_cursor(artifact: Artifact) -> void:
	fill_artifact_container(artifact)
	artifact_panel.position = get_viewport().get_mouse_position()

func fill_artifact_container(artifact: Artifact):
	$ArtifactPanel/VBoxContainer/NameLabel.text = artifact.name
	$ArtifactPanel/VBoxContainer/ValueLabel.text = "Value: " + str(artifact.value) + "$"
