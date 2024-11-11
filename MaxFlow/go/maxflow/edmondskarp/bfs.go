package edmondskarp

import "example/util/graph"

// find path
func bfs(s, t graph.Id, g graph.Graph, ok func(graph.Id, graph.Id) bool) ([]graph.Id, bool) {
	l := []graph.Id{s}
	lvl := 0

	vsd := make([]bool, g.Size())
	vsd[s] = true

	from := make([]graph.Id, g.Size())

	collectPath := func(end graph.Id, from []graph.Id, lastIndex int) []graph.Id {
		r := make([]graph.Id, lastIndex+1)
		r[lastIndex] = end

		lastIndex -= 1

		for ; lastIndex >= 0; lastIndex-- {
			r[lastIndex] = from[r[lastIndex+1]]
		}

		return r
	}

	for lt := []graph.Id{}; len(l) != 0; l, lt, lvl = lt, l[:0], lvl+1 {
		for _, x := range l {
			if x == t {
				return collectPath(t, from, lvl), true
			}

			for _, y := range g.Neighbor(x) {
				if !vsd[y] && ok(x, y) {
					vsd[y] = true
					lt = append(lt, y)
					from[y] = x
				}
			}
		}
	}

	return nil, false
}
