extends Node

# Enums
enum ArtifactName {
	NOTHING, # Does nothing (no effect)
	POCKET_WATCH,
	GOLD_RING,
	DOLL,
	SILVER_GAUNTLET,
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
		"effect": "Adds 25% to dig speed",
		"number": 0.25
	},
	ArtifactName.DOLL: {
		"name": "Doll",
		"value": 10.0,
		"rarity": Rarity.UNCOMMON,
		"effect": "Copies the effect of the artifact to the immediate right",
		"number": 0.0
	},
	ArtifactName.GOLD_RING: {
		"name": "Gold Ring",
		"value": 25.0,
		"rarity": Rarity.RARE,
		"effect": "Increases likelihood of finding artifacts in coffins by 5%",
		"number": 0.05
	},
	ArtifactName.SILVER_GAUNTLET: {
		"name": "Silver Gauntlet",
		"value": 200.0,
		"rarity": Rarity.COMMON,
		"effect": "Multiplies the dig speed by 150%",
		"number": 1.50
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
