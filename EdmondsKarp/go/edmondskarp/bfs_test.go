package edmondskarp

import (
	"slices"
	"testing"

	"example/util/graph"
	u "example/util/graph/undirected"
	. "example/util/testutil"
)

func pred(g graph.Graph) func(graph.Id, graph.Id) bool {
	return func(i1, i2 graph.Id) bool { return g.Weight(i1, i2) > 0 }
}

func TestReachable(t *testing.T) {
	var n uint = 5
	edges := graph.Slice2Edge([][]int{{0, 1, 1}, {2, 1, 1}, {2, 3, 1}, {0, 4, 1}, {3, 4, 1}})
	g := u.BuildUndirectedGraph(n, edges)

	path, ok := Bfs(0, 3, g, pred(g))

	if !ok {
		t.Fatal("path not found")
	}

	if ex := []graph.Id{0, 4, 3}; !slices.Equal(path, ex) {
		t.Fatal(Errf(path, ex))
	}
}

func TestUnreachable(t *testing.T) {
	var n uint = 5
	edges := graph.Slice2Edge([][]int{{0, 1, 10}, {2, 1, 10}, {2, 3, 0}, {0, 4, 10}, {3, 4, 0}})
	g := u.BuildUndirectedGraph(n, edges)

	path, ok := Bfs(0, 3, g, pred(g))

	if ok {
		t.Fatalf("path %v found", path)
	}
}

func TestCycle(t *testing.T) {
	var n uint = 6
	edges := graph.Slice2Edge([][]int{{0, 1, 1}, {1, 2, 1}, {1, 3, 1}, {2, 4, 1}, {3, 4, 1}, {4, 5, 1}})
	g := u.BuildUndirectedGraph(n, edges)

	path, ok := Bfs(0, 5, g, pred(g))

	if !ok {
		t.Fatal("path not found")
	}

	if ex1, ex2 := []graph.Id{0, 1, 2, 4, 5}, []graph.Id{0, 1, 3, 4, 5}; !slices.Equal(path, ex1) && !slices.Equal(path, ex2) {
		t.Fatalf("got path %v, want %v or %v", path, ex1, ex2)
	}
}

func TestSame(t *testing.T) {
	var n uint = 2
	edges := graph.Slice2Edge([][]int{{0, 1, 1}})
	g := u.BuildUndirectedGraph(n, edges)

	path, ok := Bfs(0, 0, g, pred(g))

	if !ok {
		t.Fatal("path not found")
	}

	if ex := []graph.Id{0}; !slices.Equal(path, ex) {
		t.Fatal(Errf(path, ex))
	}
}
