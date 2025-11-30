import type { Pt } from "./graphing"
import { generate_qualities } from "./qualities/parser"

export let qualities : Record<string, string[]> = generate_qualities()
export let quality_positions : Record<string, Pt> = {}
export const quality_parent = document.querySelector<HTMLDivElement>("#app")
export const svg_parent = document.querySelector<HTMLElement & SVGElement>("#app-svg")


class Globals_cls {
	public page_zoom : number = 1
}

export const Globals = new Globals_cls()
