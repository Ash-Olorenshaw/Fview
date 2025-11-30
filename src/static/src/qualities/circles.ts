import { sort_qualities } from "./common"
import { qualities, quality_parent, quality_positions, svg_parent } from "../globals"
import { calc_midpoint, type Pt } from "../graphing"
import { string_to_color } from "../utils"
import van from "vanjs-core"

const { div } = van.tags

let furthest_x = 0
let furthest_y = 0
const quality_stack = sort_qualities()

function add_quality_pos(qual : string, pos : Pt) : void {
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

const QualityTag = (
	{ text, radius, color } : { text : string, radius : number, color : string }
) => div(
	{ 
		style: `width: ${radius * 2}px; height: ${radius * 2}px; background-color: ${color};`,
		class: "quality-tag"
	},
	text
)

export function generate_quality_circles() {
	if (!quality_parent)
		return

	furthest_x = 0
	furthest_y = 0

	let skipped_loop = 0

	while (quality_stack.length > 0) {
		const quality = quality_stack.at(-1)
		if (!quality)
			break

		const quality_children = qualities[quality]
		const tag_radius = (quality_children.length + 1) * 50
		const quality_tag = QualityTag({ 
			text : quality, 
			radius : tag_radius, 
			color : string_to_color(quality) 
		})

		van.add(quality_parent, quality_tag)

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
		svg_parent.style.width = `${furthest_x}px`
		svg_parent.style.height = `${furthest_y}px`
	}
}

