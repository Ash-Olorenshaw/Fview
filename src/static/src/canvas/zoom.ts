import van from "vanjs-core";
import { Globals, quality_parent } from "../globals";
const { div, button } = van.tags

function zoom(dir : number) {
	if (quality_parent) {
		if (dir > 0) {
			if (Globals.page_zoom < 2) {
				Globals.page_zoom += 0.1
			}
		}
		else {
			if (Globals.page_zoom > 0.5) {
				Globals.page_zoom -= 0.1
			}
		}

		quality_parent.style.zoom = `${Globals.page_zoom}`
	}
}

export function setup_zoom() {
	const ZoomButtons = () => div(
		{ style: "display: flex; flex-direction: column; position: absolute; right: 0; bottom: 0;" },
		button({ onclick: () => zoom(1), class: "zoom-button" }, "+"),
		button({ onclick: () => zoom(-1), class: "zoom-button" }, "-")
	)

	van.add(document.body, ZoomButtons())

	document.addEventListener("keydown", (event : KeyboardEvent) => {
		if (event.ctrlKey == true && (event.key == 'Subtract' || event.key == 'Add' || event.key == '-' || event.key == '+'  || event.key == '_'  || event.key == '=')) {
			event.preventDefault();
			if (event.key == "Subtract" || event.key == "-" || event.key == "_")
				zoom(-1)
			else
				zoom(1)
		}
	});

	window.addEventListener('wheel', (event : WheelEvent) => {
		if (event.ctrlKey == true) {
			event.preventDefault();
			if (event.deltaY < 0)
				zoom(1)
			else
				zoom(-1)
		}
	});
}
