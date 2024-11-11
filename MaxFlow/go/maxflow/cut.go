// min cut

package maxflow

import (
	g "example/util/graph"
	f "example/util/graph/undirected/flow"
)

func MinCutSize(s g.Id, flowed f.FlowNetwork) f.Flow {
	var size f.Flow = 0

	for _, v := range flowed.Neighbor(s) {
		size += flowed.Flow(s, v)
	}

	return size
}

func MinCutSeparateNodes(s g.Id, flowed f.FlowNetwork) (sources, sinks []g.Id) {
	vsd := make([]bool, flowed.Size())

	l := []g.Id{s}
	vsd[s] = true
	for len(l) > 0 {
		v := l[len(l)-1]
		l = l[:len(l)-1]

		for _, w := range flowed.Neighbor(v) {
			if flowed.Residual(v, w) > 0 && !vsd[w] {
				l = append(l, w)
				vsd[w] = true
			}
		}
	}

	for i, b := range vsd {
		if b {
			sources = append(sources, g.Id(i))
		} else {
			sinks = append(sinks, g.Id(i))
		}
	}

	return sources, sinks
}

func MinCutEdges(sources []g.Id, graph g.Graph) []g.Edge {
	edges := make([]g.Edge, 0)

	s := make([]bool, graph.Size())
	for _, v := range sources {
		s[v] = true
	}

	for _, v := range sources {
		for _, w := range graph.Neighbor(v) {
			if !s[w] {
				edges = append(edges, g.Edge{X: v, Y: w, C: graph.Weight(v, w)})
			}
		}
	}

	return edges
}
