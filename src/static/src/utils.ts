export function string_to_color(target : string) {
	let hash = 0
	target.split("").forEach(char => {
		hash = char.charCodeAt(0) + ((hash << 5) - hash)
	})
	let color = "#"
	for (let i = 0; i < 3; i++) {
		const value = (hash >> (i * 8)) & 0xff
		color += value.toString(16).padStart(2, '0')
	}
	return color
}

export function rand_sign() : number {
	let result = (Math.floor(Math.random() * 2) - 1)
	return result != 0 ? result : rand_sign()
}

export function raise_err(msg : string) {
	alert(msg)
	throw msg
}
