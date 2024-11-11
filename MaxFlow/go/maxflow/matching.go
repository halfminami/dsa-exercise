// bipartite matching

package maxflow

import (
	g "example/util/graph"
	u "example/util/graph/undirected"
	f "example/util/graph/undirected/flow"
)

func BipartiteMatchingGraph(n uint, a, b []g.Id, es [][2]g.Id) (size uint, s, t g.Id, edges []g.Edge) {
	for _, pair := range es {
		edges = append(edges, g.Edge{X: pair[0], Y: pair[1], C: 1})
	}

	var aa, ab []g.Edge

	s, size, aa = u.SuperNode(n, a, 1)
	t, size, ab = u.SuperNode(size, b, 1)

	return size, s, t, append(append(edges, aa...), ab...)
}

func BipartiteMatching(a, b []g.Id, edges [][2]g.Id, flowed f.FlowNetwork) [][2]g.Id {
	r := make([][2]g.Id, 0, min(len(a), len(b)))

	for _, pair := range edges {
		x, y := pair[0], pair[1]
		if flowed.Residual(x, y) == 0 || flowed.Residual(y, x) == 0 {
			r = append(r, pair)
		}
	}

	return r
}
