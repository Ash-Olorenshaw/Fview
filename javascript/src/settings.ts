import van from "vanjs-core";
import { close_side_panel, SidePanelCloseButton } from "./sidepanel";
import { raise_err } from "./utils";
const { div, button, h1 } = van.tags

export const SettingsButton = () => button(
	{ 
		class: "settings-button",
		onclick : open_settings
	}, 
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
			SidePanelCloseButton({}),
			div(
				h1(
					"Settings"
				),
				button(
					{ 
						class : "normal-button",
						onclick: async () => {
							const { success, success_reason } = await window.openQualitiesDir()
							if (!success)
								raise_err(success_reason)
						} 
					},
					"Open qualities folder"
				)
			)
		)

		van.add(document.body, SidePanel())
	}
}
