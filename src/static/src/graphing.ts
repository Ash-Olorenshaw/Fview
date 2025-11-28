export type Pt = { x : number; y : number }

export function calc_midpoint(points : Pt[]) {
	const sum = points.reduce(
		(acc, p) => {
			acc.x += p.x
			acc.y += p.y
			acc.x = Math.floor(acc.x)
			acc.y = Math.floor(acc.y)
			return acc
		},
		{ x : 0, y : 0 }
	)

	return {
		x : sum.x / points.length,
		y : sum.y / points.length
	}
}
