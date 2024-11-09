// undirected graph implementation

package undirected

import (
	. "example/util/graph"
	internal "example/util/graph/internal"
)

type undirectedGraph struct {
	size     uint
	adjacent [][]Id
	weight   []map[Id]Weight
}

func (g undirectedGraph) Size() uint         { return g.size }
func (g undirectedGraph) Neighbor(v Id) []Id { return g.adjacent[v] }

// edge must be present
func (g undirectedGraph) Weight(a, b Id) Weight {
	w, ok := g.weight[a][b]
	if ok {
		return w
	}

	return g.weight[b][a]
}

// input is undirected simple graph
// this constructs undirected graph
func BuildUndirectedGraph(size uint, edges []Edge) Graph {
	adjacent := internal.MakeAdjacencyList[Id](size)
	for _, edge := range edges {
		adjacent[edge.X] = append(adjacent[edge.X], edge.Y)
		adjacent[edge.Y] = append(adjacent[edge.Y], edge.X)
	}

	weight := internal.MakeAdjacencyMap[Weight, Id](size)
	for _, edge := range edges {
		weight[edge.X][edge.Y] = edge.C
	}

	return undirectedGraph{size, adjacent, weight}
}

// add a supernode that connects to set of vertices
func SuperNodes(size uint, vertices []Id, newWeight Weight) (super Id, n uint, additional []Edge) {
	super = Id(size)
	n = size + 1

	additional = make([]Edge, 0, len(vertices))

	for _, s := range vertices {
		additional = append(additional, Edge{X: super, Y: s, C: newWeight})
	}

	return super, n, additional
}
