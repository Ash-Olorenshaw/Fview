import { sort_qualities } from "./common"
import { qualities, quality_positions } from "../globals"
import { calc_midpoint, type Pt } from "../graphing"
import { string_to_color } from "../utils"

let furthest_x = 0
let furthest_y = 0
const quality_stack = sort_qualities()

function add_quality_pos(qual : string, pos : Pt) : void {
	console.log(`ADDING QUALITY: ${qual} (${pos.x}, ${pos.y})`)
	quality_positions[qual] = pos
	if (pos.x > furthest_x)
		furthest_x = pos.x
	if (pos.y > furthest_y)
		furthest_y = pos.y

	quality_stack.pop()
}

function quality_pos_exists(pos : Pt) : boolean {
	return Object.values(quality_positions).some((val : Pt) => {
		return Math.abs(pos.x - val.x) < 20 && Math.abs(pos.y - val.y) < 20
	})
}

export function generate_quality_circles() {
	furthest_x = 0
	furthest_y = 0

	const quality_parent = document.querySelector<HTMLDivElement>("#app")
	const svg_parent = document.querySelector<HTMLElement & SVGElement>("#app-svg")

	let skipped_loop = 0

	while (quality_stack.length > 0) {
		const quality = quality_stack.at(-1)
		if (!quality)
			break

		const quality_children = qualities[quality]
		const quality_tag = document.createElement("div")
		const tag_radius = (quality_children.length + 1) * 50

		quality_tag.textContent = quality
		quality_parent?.appendChild(quality_tag)

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

		const quality_position_names = Object.keys(quality_positions)
		if (quality_position_names.length > 2) {
			if (relation_pts.length < 2) {
				if (skipped_loop >= quality_stack.length) {
					relation_pts.push(quality_positions[quality_position_names[Math.floor(Math.random() * quality_position_names.length)]])
				}
				else {
					skipped_loop++
					quality_tag.remove()
					continue
				}
			}
			else {
				skipped_loop = 0
			}

			let mid_point = calc_midpoint(relation_pts)
			
			if (quality_pos_exists(mid_point)) {
				console.log(`updating midpoint (${mid_point.x}, ${mid_point.y})`)
				relation_pts.push(quality_positions[quality_position_names[Math.floor(Math.random() * quality_position_names.length)]])
				mid_point = calc_midpoint(relation_pts)
				console.log(`\t->(${mid_point.x}, ${mid_point.y})`)
			}

			quality_tag.style.left = `${mid_point.x}px`
			quality_tag.style.top = `${mid_point.y}px`
			add_quality_pos(quality, { x : (mid_point.x + tag_radius), y : (mid_point.y + tag_radius) })
		}
		else {
			if (quality_position_names.length == 2) {
				quality_tag.style.left = "1920px"
				quality_tag.style.top = "1080px"
				add_quality_pos(quality, { x : (quality_tag.offsetLeft + tag_radius), y : (quality_tag.offsetTop + tag_radius) })
			}
			else if (quality_position_names.length == 1) {
				quality_tag.style.left = "1920px"
				add_quality_pos(quality, { x : (quality_tag.offsetLeft + tag_radius), y : tag_radius })
			}
			else {
				add_quality_pos(quality, { x : tag_radius, y : tag_radius })
			}
		}
	}

	if (quality_parent && svg_parent) {
		quality_parent.style.width = `${furthest_x}px`
		quality_parent.style.height = `${furthest_y}px`
		svg_parent.style.width = `${furthest_x}px`
		svg_parent.style.height = `${furthest_y}px`
	}
}

