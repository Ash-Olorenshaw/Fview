import './style.css'

type Pt = { x : number; y : number }

let qualities : Record<string, string[]> = {
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

let quality_positions : Record<string, Pt> = {}

function string_to_color(target : string) {
	let hash = 0
	target.split("").forEach(char => {
		hash = char.charCodeAt(0) + ((hash << 5) - hash)
	})
	let color = "#"
	for (let i = 0; i < 3; i++) {
		const value = (hash >> (i * 8)) & 0xff
		color += value.toString(16).padStart(2, '0')
	}
	return color
}

/* function calc_tag_pos(childDeg : number, tagRadius : number) {
	const rad = (childDeg * Math.PI) / 180
	const x = tagRadius * Math.sin(rad)
	const y = -tagRadius * Math.cos(rad)
	return { x, y };
} */

function sort_qualities() {
	return Object.keys(qualities).sort((a, b) => {
		if (qualities[a].length > qualities[b].length)
			return 1
		else if (qualities[a].length < qualities[b].length)
			return -1
		return 0
	})
}

function calc_midpoint(points : Pt[]) {
	const sum = points.reduce(
		(acc, p) => {
			acc.x += p.x
			acc.y += p.y
			return acc
		},
		{ x : 0, y : 0 }
	)

	return {
		x : sum.x / points.length,
		y : sum.y / points.length
	}
}

for (const quality of sort_qualities()) {
	const quality_tag = document.createElement("div")
	quality_tag.textContent = quality
	const quality_children = qualities[quality]
	const quality_parent = document.querySelector<HTMLDivElement>("#app")
	quality_parent?.appendChild(quality_tag)
	const tag_radius = (quality_children.length + 1) * 50
	quality_tag.style.borderRadius = "100%" 
	quality_tag.style.width = `${tag_radius * 2}px` 
	quality_tag.style.height = `${tag_radius * 2}px` 
	quality_tag.style.opacity = "0.5"
	quality_tag.style.position = "absolute"
	quality_tag.style.alignContent = "center"
	quality_tag.style.textAlign = "center"
	quality_tag.style.backgroundColor = string_to_color(quality)

	const relation_pts : Pt[] = []
	for (const quality_child of quality_children) {
		const quality_pos  = quality_positions[quality_child]
		if (quality_pos)
			relation_pts.push(quality_pos)
	}

	if (relation_pts.length > 2) {
		const mid_point = calc_midpoint(relation_pts)
		const tag_w = quality_tag.offsetWidth
		const tag_h = quality_tag.offsetHeight
		quality_tag.style.left = `${mid_point.x}px`
		quality_tag.style.top = `${mid_point.y}px`
		quality_positions[quality] = { x : (mid_point.x + tag_w / 2), y : (mid_point.y + tag_h / 2) }
	}
	else if (relation_pts.length == 2) {
		const tag_w = quality_tag.offsetWidth
		const tag_h = quality_tag.offsetHeight
		quality_tag.style.right = "0"
		quality_tag.style.bottom = "0"
		quality_positions[quality] = { x : (quality_tag.offsetLeft + tag_w / 2), y : (quality_tag.offsetTop + tag_h / 2) }

	}
	else if (relation_pts.length == 1) {
		const tag_w = quality_tag.offsetWidth
		const tag_h = quality_tag.offsetHeight
		quality_tag.style.right = "0"
		quality_positions[quality] = { x : (quality_tag.offsetLeft + tag_w / 2), y : tag_h / 2 }
	}
	else {
		const tag_w = quality_tag.offsetWidth
		const tag_h = quality_tag.offsetHeight
		quality_positions[quality] = { x : tag_w / 2, y : tag_h / 2 }
	}
	

	/* console.log(string_to_color(quality))
	const child_deg = 360 / quality_children.length
	const deg_offset = Math.floor(Math.random() * 10) + 5
	for (const [ child_i, quality_child ] of quality_children.entries()) {
		if (!(quality_child in qualities)) {
			const current_deg = (child_deg * child_i)
			const { x, y } = calc_tag_pos(current_deg, tag_radius * 2/3)
			console.log(`TAG: (${child_deg}deg) (${x}, ${y})`)
			const quality_child_tag = document.createElement("div")
			quality_child_tag.style.position = "absolute"
			// quality_child_tag.style.left = `${x + (tag_radius)}px`
			// quality_child_tag.style.top = `${y + (tag_radius)}px`
			quality_child_tag.textContent = quality_child
			quality_tag.appendChild(quality_child_tag)

			const tag_w = quality_child_tag.offsetWidth
			const tag_h = quality_child_tag.offsetHeight

			quality_child_tag.style.marginLeft = `${-tag_w / 2}px`
			quality_child_tag.style.marginTop = `${-tag_h / 2}px`
			quality_child_tag.style.transform = `translate(${x + tag_radius}px, ${y}px)`
		}
	} */
}
