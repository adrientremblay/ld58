extends Control

# Children
@onready var money_label: Label = $AnchorTopRight/VBoxContainer/MoneyLabel
@onready var artifact_panel: PanelContainer = $ArtifactPanel
@onready var interact_label: Label = $MarginBottom/InteractLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	artifact_panel.visible = false
	interact_label.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_money_label(money: float):
	# calculate the value
	money_label.text = "Money: " + str(money) + "$"
	$SellArtifactSound.play()

func _on_grave_move_artifact_label_to_cursor(artifact: Artifact) -> void:
	if not artifact:
		artifact_panel.visible = false
		return

	artifact_panel.visible = true
	
	fill_artifact_container(artifact)
	artifact_panel.position = get_viewport().get_mouse_position()

func fill_artifact_container(artifact: Artifact):
	$ArtifactPanel/VBoxContainer/NameLabel.text = artifact.artifact_name
	$ArtifactPanel/VBoxContainer/ValueLabel.text = "Collection Value: " + str(artifact.value) + "$"

func _on_player_player_can_interact(interact_message: String) -> void:
	interact_label.text = interact_message

func _on_player_player_can_no_longer_interact() -> void:
	interact_label.text = ""
