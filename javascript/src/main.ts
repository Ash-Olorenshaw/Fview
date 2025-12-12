import { generate_quality_circles } from './qualities/circles'
import { generate_quality_lines } from './qualities/lines'
import './style.css'
import { setup_zoom } from './canvas/zoom'
import { setup_pan } from './canvas/pan'
import { setup_href_redirect } from './link_utils'

/* function calc_tag_pos(childDeg : number, tagRadius : number) {
	const rad = (childDeg * Math.PI) / 180
	const x = tagRadius * Math.sin(rad)
	const y = -tagRadius * Math.cos(rad)
	return { x, y };
} */

setup_zoom()
setup_pan()
setup_href_redirect()
generate_quality_circles()
generate_quality_lines()

console.log("finished drawing all qualities")
