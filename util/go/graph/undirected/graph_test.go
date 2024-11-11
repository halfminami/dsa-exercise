package undirected

import (
	"testing"

	. "example/util/graph"
	. "example/util/testutil"
)

func graphRun(t *testing.T, g Graph, n uint, neighbors [][]Id) {
	if got, ex := g.Size(), n; got != ex {
		t.Error(Errf(got, ex))
	}

	for i, neighbor := range neighbors {
		if got, ex := g.Neighbor(Id(i)), neighbor; !SlicesEqualUnordered(got, ex, func(a, b Id) int { return int(a) - int(b) }, func(a, b Id) bool { return a == b }) {
			t.Error(Errf(got, ex))
		}
	}
}

func TestSmall(t *testing.T) {
	g := BuildGraph(2, Slice2Edge([][]int{{0, 1, 2}}))

	graphRun(t, g, 2, [][]Id{{1}, {0}})
}

func TestComplete(t *testing.T) {
	g := BuildGraph(4, Slice2Edge([][]int{{0, 1, 0}, {0, 2, 0}, {0, 3, 0}, {1, 2, 0}, {1, 3, 0}, {2, 3, 0}}))

	graphRun(t, g, 4, [][]Id{{1, 2, 3}, {0, 2, 3}, {0, 1, 3}, {0, 1, 2}})
}

func TestCompleteBipartite(t *testing.T) {
	g := BuildGraph(6, Slice2Edge([][]int{{3, 0, 0}, {4, 0, 0}, {0, 5, 0}, {3, 1, 0}, {1, 4, 0}, {1, 5, 0}, {3, 2, 0}, {2, 4, 0}, {2, 5, 0}}))

	graphRun(t, g, 6, [][]Id{{3, 4, 5}, {3, 4, 5}, {3, 4, 5}, {0, 1, 2}, {0, 1, 2}, {0, 1, 2}})
}

func TestNoEdge(t *testing.T) {
	g := BuildGraph(1, []Edge{})

	graphRun(t, g, 1, [][]Id{{}})
}
