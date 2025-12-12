import van from "vanjs-core";
import { close_side_panel, SidePanelCloseButton } from "./sidepanel";
const { div, button } = van.tags

export const SettingsButton = () => button(
	{ class: "settings-button" }, 
	div(
		{ class : "settings-gear" }
	)
)

export async function open_settings() {
	const side_panel = document.getElementById("side-panel")

	if (side_panel)
		close_side_panel()
	else {
		const SidePanel = () => div(
			{ 
				id: "side-panel",
			},
			SidePanelCloseButton()
		)

		van.add(document.body, SidePanel())
	}
}
