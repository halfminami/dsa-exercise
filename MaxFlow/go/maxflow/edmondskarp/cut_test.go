package edmondskarp_test

import (
	"testing"

	u "example/algorithm/maxflow"
	this "example/algorithm/maxflow/edmondskarp"
	"example/util/graph"
	"example/util/graph/undirected/flow"
	. "example/util/testutil"
)

func flowRun(t *testing.T, flowed flow.FlowNetwork, ex [][3]int) {
	for _, tup := range ex {
		x, y, ex := graph.Id(tup[0]), graph.Id(tup[1]), flow.Flow(tup[2])

		if got := flowed.Flow(x, y); got != ex {
			t.Errorf("edge (%d, %d): %s", x, y, Errf(got, ex))
		}
	}
}

func edgeCutRun(t *testing.T, s graph.Id, f flow.FlowNetwork, ex []graph.Edge) {
	sources, _ := u.MinCutSeparateNodes(s, f)
	got := u.MinCutEdges(sources, f)

	if !edgeUnordered(got, ex) {
		t.Error(Errf(got, ex))
	}
}

func cmpEdgeXY(a, b graph.Edge) int {
	ax, ay := a.X, a.Y
	bx, by := b.X, b.Y
	if ax > ay {
		ax, ay = ay, ax
	}
	if bx > by {
		bx, by = by, bx
	}

	if ax == bx {
		return int(ay) - int(by)
	}
	return int(ax) - int(bx)
}

func edgeUnordered(a, b []graph.Edge) bool {
	return SlicesEqualUnordered(a, b, func(a, b graph.Edge) int {
		if p := cmpEdgeXY(a, b); p != 0 {
			return p
		} else {
			return int(a.C) - int(b.C)
		}
	},
		func(a, b graph.Edge) bool {
			if p := cmpEdgeXY(a, b); p != 0 {
				return false
			} else {
				return a.C == b.C
			}
		})
}

func TestBlocked(t *testing.T) {
	f := this.MaxFlowSingle(6, 0, 5, graph.Slice2Edge([][]int{{0, 1, 99}, {0, 2, 2}, {1, 3, 99}, {2, 4, 99}, {3, 2, 99}, {3, 5, 2}, {4, 5, 10}}))

	flowRun(t, f, [][3]int{{0, 1, 10}, {0, 2, 2}, {1, 3, 10}, {3, 2, 8}, {2, 4, 10}, {3, 5, 2}, {4, 5, 10}})

	edgeCutRun(t, 0, f, graph.Slice2Edge([][]int{{3, 5, 2}, {4, 5, 10}}))
}

func TestMultiSimple(t *testing.T) {
	s, _, f := this.MaxFlowSets(6, []graph.Id{0, 1, 2}, []graph.Id{3, 4, 5}, graph.Slice2Edge([][]int{{0, 3, 2}, {4, 1, 2}, {5, 2, 1}}))

	flowRun(t, f, [][3]int{{0, 3, 2}, {1, 4, 2}, {2, 5, 1}})

	edgeCutRun(t, s, f, graph.Slice2Edge([][]int{{0, 3, 2}, {1, 4, 2}, {2, 5, 1}}))
}

func TestMulti1(t *testing.T) {
	// 10 is isolated!
	s, _, f := this.MaxFlowSets(11, []graph.Id{0, 1, 2}, []graph.Id{8, 9, 10}, graph.Slice2Edge([][]int{{0, 3, 10}, {1, 4, 10}, {2, 5, 10}, {3, 6, 5}, {3, 7, 3}, {6, 7, 2}, {4, 5, 4}, {4, 7, 5}, {5, 7, 1}, {7, 8, 99}, {7, 9, 99}}))

	flowRun(t, f, [][3]int{{0, 3, 5}, {3, 6, 2}, {6, 7, 2}, {3, 7, 3}, {4, 7, 5}, {5, 7, 1}})

	edgeCutRun(t, s, f, graph.Slice2Edge([][]int{{6, 7, 2}, {3, 7, 3}, {4, 7, 5}, {5, 7, 1}}))
}

func TestMulti2(t *testing.T) {
	s, _, f := this.MaxFlowSets(11, []graph.Id{0, 1, 2}, []graph.Id{8, 9, 10}, graph.Slice2Edge([][]int{{0, 3, 10}, {1, 4, 10}, {2, 5, 1}, {3, 6, 5}, {3, 7, 3}, {6, 7, 2}, {4, 5, 4}, {4, 7, 5}, {5, 7, 10}, {7, 8, 99}, {7, 9, 99}}))

	flowRun(t, f, [][3]int{{0, 3, 5}, {3, 6, 2}, {6, 7, 2}, {3, 7, 3}, {4, 7, 5}, {4, 5, 4}, {2, 5, 1}})

	edgeCutRun(t, s, f, graph.Slice2Edge([][]int{{6, 7, 2}, {3, 7, 3}, {4, 7, 5}, {4, 5, 4}, {2, 5, 1}}))
}

func TestMulti3(t *testing.T) {
	s, _, f := this.MaxFlowSets(11, []graph.Id{0, 1, 2}, []graph.Id{8, 9, 10}, graph.Slice2Edge([][]int{{0, 3, 10}, {1, 4, 8}, {2, 5, 1}, {3, 6, 5}, {3, 7, 3}, {6, 7, 2}, {4, 5, 4}, {4, 7, 5}, {5, 7, 10}, {7, 8, 99}, {7, 9, 99}}))

	flowRun(t, f, [][3]int{{0, 3, 5}, {3, 6, 2}, {6, 7, 2}, {3, 7, 3}, {1, 4, 8}, {2, 5, 1}})

	edgeCutRun(t, s, f, graph.Slice2Edge([][]int{{6, 7, 2}, {3, 7, 3}, {1, 4, 8}, {2, 5, 1}}))
}
