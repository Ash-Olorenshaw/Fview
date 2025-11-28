import type { Pt } from "./graphing"

export let qualities : Record<string, string[]> = {
	"reliable" : [ "responsible" ],
	"responsible" : [
		"reliable",
		"self control"
	],
	"self control" : [
		"responsible",
		"patience",
		"moderation",
		"determination",
		"endurance"
	],
	"moderation" : [ "self control" ],
	"determination" : [ "self control" ],
	"patience" : [
		"self control",
		"endurance",
		"empathy",
		"humility"
	],
	"empathy" : [ "patience" ],
	"humility" : [ "patience" ],
	"endurance" : [
		"self control",
		"patience",
		"hope",
		"loyalty",
		"joy"
		// TODO: this is unfinished
	],
	"hope" : [ "endurance" ],
	"loyalty" : [ "endurance" ],
	"joy": [ "endurance" ],
}

export let quality_positions : Record<string, Pt> = {}
