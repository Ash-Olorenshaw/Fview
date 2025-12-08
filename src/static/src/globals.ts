import van, { type State } from "vanjs-core"
import type { Pt } from "./graphing"
import { generate_qualities } from "./qualities/parser"

export let qualities : Record<string, string[]> = generate_qualities()
export let quality_positions : Record<string, Pt> = {}
export let quality_descriptions : Record<string, HTMLElement> = {}
export const quality_parent = document.querySelector<HTMLDivElement>("#app")
export const svg_parent = document.querySelector<HTMLElement & SVGElement>("#app-svg")


class Globals_cls {
	public page_zoom : State<number> = van.state(1)
}

export const Globals = new Globals_cls()
