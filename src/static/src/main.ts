import { generate_quality_circles } from './qualities/circles'
import { generate_quality_lines } from './qualities/lines'
import './style.css'

/* function calc_tag_pos(childDeg : number, tagRadius : number) {
	const rad = (childDeg * Math.PI) / 180
	const x = tagRadius * Math.sin(rad)
	const y = -tagRadius * Math.cos(rad)
	return { x, y };
} */

generate_quality_circles()
generate_quality_lines()

console.log("finished drawing all qualities")
