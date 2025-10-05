extends Node

# Enums
enum ArtifactName {
	POCKET_WATCH,
	GOLD_RING
}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE
}

# Variables
var score = 0.0
var survived: bool = false

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

# Spawn chance as a decimal percentage
const SPAWN_CHANCE_MAP = {
	Rarity.COMMON: 0.95,
	Rarity.UNCOMMON: 0.80,
	Rarity.RARE: 0.50,
}
