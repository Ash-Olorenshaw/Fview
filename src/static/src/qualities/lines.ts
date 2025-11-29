import { qualities, quality_positions } from "../globals"
import type { Pt } from "../graphing"
import { raise_err } from "../utils"

function draw_line(pos1 : Pt, pos2 : Pt) {
	const svg_parent = document.querySelector<HTMLElement & SVGElement>("#app-svg")
	const svg_line = document.createElementNS("http://www.w3.org/2000/svg", "line")
	svg_line.setAttribute("x1", `${pos1.x}`)
	svg_line.setAttribute("x2", `${pos2.x}`)
	svg_line.setAttribute("y1", `${pos1.y}`)
	svg_line.setAttribute("y2", `${pos2.y}`)
	svg_line.setAttribute("stroke", "black")
	svg_line.style.color = "black"
	svg_parent?.appendChild(svg_line)
}

function test_quality_connections() {
	for (const quality in qualities) {
		const quality_children = qualities[quality]
		for (const quality_child of quality_children) {
			if (!(quality_child in qualities)) {
				raise_err(`Error - Missing quality '${quality_child}' referenced by quality '${quality}'`)
			}
			else if (!qualities[quality_child].includes(quality)) {
				raise_err(`Error - Please ensure all qualities reference each other. Quality '${quality}' references quality '${quality_child}', but '${quality_child}' does not reference '${quality}' in return.`)
			}
		}
	}
}

export function generate_quality_lines() {
	test_quality_connections()
	for (const quality in qualities) {
		const parent_pos = quality_positions[quality]
		const quality_children = qualities[quality]
		for (const quality_child of quality_children) {
			const child_pos = quality_positions[quality_child]
			draw_line(parent_pos, child_pos)
		}
	}
}

