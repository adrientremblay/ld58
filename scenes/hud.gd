extends Control

# Children
@onready var money_label: Label = $AnchorTopRight/VBoxContainer/MoneyLabel
@onready var artifact_panel: PanelContainer = $ArtifactPanel
@onready var interact_label: Label = $MarginBottom/InteractLabel
@onready var rarity_label: Label = $ArtifactPanel/VBoxContainer/HBoxContainer/RarityLabel
@onready var help_label : Label = $AnchorBottomRight/HelpLabel

# Constants
var main_text: String = "[W,S,A,D] - Move
						[SHIFT] - Sprint
						[E] - Dig Up Grave
						[C] - View Collection"

# Properties TODO this is kinda dumb
var looking_at_collection: bool = false
var looking_at_grave: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	artifact_panel.visible = false
	interact_label.text = ""
	help_label.text = main_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_money_label(money: float):
	# calculate the value
	money_label.text = "Collection Value: " + str(money) + "$"
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
	
	match artifact.rarity:
		Global.Rarity.COMMON:
			rarity_label.text = "Common"
			rarity_label.label_settings.font_color = Color.WHITE
		Global.Rarity.UNCOMMON:
			rarity_label.text = "Uncommon"
			rarity_label.label_settings.font_color = Color.LIGHT_GREEN
		Global.Rarity.RARE:
			rarity_label.text = "Rare"
			rarity_label.label_settings.font_color = Color.TOMATO

func _on_player_player_can_interact(interact_message: String) -> void:
	interact_label.text = interact_message

func _on_player_player_can_no_longer_interact() -> void:
	interact_label.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("collection"):
		looking_at_collection = not looking_at_collection
		if looking_at_collection:
			help_label.text = "[MOUSE] - Drag and drop artifacts
							[C] - Leave Collection"
		else:
			help_label.text = main_text
