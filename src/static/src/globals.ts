import type { Pt } from "./graphing"
import { generate_qualities } from "./qualities/parser"

export let qualities : Record<string, string[]> = generate_qualities()
export let quality_positions : Record<string, Pt> = {}
