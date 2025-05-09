extends Node


#primary weapons
const _RIFLE := "res://scenes/game_objects/weapons/range_weapons/rifle/rifle.tscn"
const _SHOTGUN := "res://scenes/game_objects/weapons/range_weapons/shotgun/shotgun.tscn"
const _ENERGY_BATTLE_RIFLE := "res://scenes/game_objects/weapons/range_weapons/energy_battle_rifle/energy_battle_rifle.tscn"
const _REVOLVER_ENERGY := "res://scenes/game_objects/weapons/range_weapons/energy_revolver/energy_revolver.tscn"

var available_primary_weapons := [
	_ENERGY_BATTLE_RIFLE,
	_REVOLVER_ENERGY
]


#support weapons
const _CHAINSAW := "res://scenes/game_objects/weapons/melee_weapons/chainsaw/chainsaw.tscn"
const _GAUTLENT := ""
const _GATLING := "res://scenes/game_objects/weapons/range_weapons/gatling/gatling.tscn"
const _PILE_BUNKER := ""
const _KATANA := ""
const _MISSILE_LAUNCHER := ""
const _ENERGY_SWORD := ""
const _ENERGY_SPEAR := ""
const _RAIL_CANNON := "res://scenes/game_objects/weapons/range_weapons/rail_cannon/rail_cannon.tscn"

var available_support_weapon = _RAIL_CANNON
