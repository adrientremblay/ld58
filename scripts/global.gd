extends Node

# Enums
enum ArtifactName {
	POCKET_WATCH,
	GOLD_RING,
	NOTHING
}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE
}

# Constants
const ARTIFACT_DATA = {
	ArtifactName.POCKET_WATCH: {
		"name": "Pocket Watch",
		"value": 5.0,
		"rarity": Rarity.COMMON,
		"effect": "Increases dig speed by 5%"
	},
	ArtifactName.GOLD_RING: {
		"name": "Gold Ring",
		"value": 25.0,
		"rarity": Rarity.RARE,
		"effect": "Increases likelihood of rare items spawning by 5%"
	}
}

const SPAWN_CHANCE_MAP = { # Spawn chance as a decimal percentage
	Rarity.COMMON: 0.95,
	Rarity.UNCOMMON: 0.80,
	Rarity.RARE: 0.50,
}

# Variables
var score = 0.0
var survived: bool = false
var active_upgrades: Array[ArtifactName] = [
	ArtifactName.NOTHING,
	ArtifactName.NOTHING,
	ArtifactName.NOTHING,
	ArtifactName.NOTHING,
	ArtifactName.NOTHING,
] #always length 5
