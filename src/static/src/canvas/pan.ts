import { Globals, quality_parent } from "../globals"

function is_pan_action(e : MouseEvent) {
	return ((e.buttons === 1 || e.buttons === 2) && e.ctrlKey) || e.buttons === 4
}

export function setup_pan() {
	let mouse_state : undefined | { x : number, y: number }

	document.addEventListener("mousedown", (e : MouseEvent) => {
		if (!mouse_state && is_pan_action(e)) 
			mouse_state = { x : e.pageX, y : e.pageY }
	})

	document.addEventListener("mouseup", () => {
		if (mouse_state) 
			mouse_state = undefined
	})

	document.addEventListener("mousemove", (e : MouseEvent) => {
		if (quality_parent && mouse_state) {
			let delta_x = (e.pageX - mouse_state.x) / Globals.page_zoom
			let delta_y = (e.pageY - mouse_state.y) / Globals.page_zoom

			const offset = { x: quality_parent.scrollLeft, y : quality_parent.scrollTop }
			quality_parent.scroll(offset.x - delta_x, offset.y - delta_y)

			mouse_state.x = e.pageX
			mouse_state.y = e.pageY
		}
	})
}
