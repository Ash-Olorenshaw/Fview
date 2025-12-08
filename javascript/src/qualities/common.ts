import { qualities } from "../globals"

export function sort_qualities() {
	return Object.keys(qualities).sort((a, b) => {
		if (qualities[a].length > qualities[b].length)
			return 1
		else if (qualities[a].length < qualities[b].length)
			return -1
		return 0
	})
}

