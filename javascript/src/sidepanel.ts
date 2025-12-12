import { parse } from "marked";
import van from "vanjs-core";
const { div, button } = van.tags

export const SidePanelCloseButton = () => button(
	{ 
		style: "position: absolute; right: 10px; top: 10px;",
		onclick: close_side_panel,
		class: "zoom-button"
	},
	"x"
)

export async function open_side_panel(content : string) {
	const side_panel = document.getElementById("side-panel")
	const html_nodes = await parse(content)

	if (side_panel) {
		for (const child of side_panel.children)
			child.remove()
		
		side_panel.innerHTML = html_nodes
		van.add(side_panel, SidePanelCloseButton())
	}
	else {
		const SidePanel = () => div(
			{ 
				id: "side-panel",
				innerHTML : html_nodes
			},
			SidePanelCloseButton()
		)

		van.add(document.body, SidePanel())
	}
}

export function close_side_panel() {
	document.getElementById("side-panel")?.remove()
}
