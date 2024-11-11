package edmondskarp_test

import (
	"testing"

	u "example/algorithm/maxflow"
	this "example/algorithm/maxflow/edmondskarp"
	"example/util/graph"
	. "example/util/testutil"
)

func matchingUnordered(a, b [][2]graph.Id) bool {
	// edge order should be preserved
	return SlicesEqualUnordered(a, b, func(a, b [2]graph.Id) int {
		if a[0] == b[0] {
			return int(a[1]) - int(b[1])
		}
		return int(a[0]) - int(b[0])
	}, func(a, b [2]graph.Id) bool { return a == b })
}

func TestMatchingMany(test *testing.T) {
	a, b := []graph.Id{0, 1, 2, 3, 4}, []graph.Id{5, 6, 7, 8, 9}
	es := [][2]graph.Id{{0, 5}, {0, 7}, {1, 5}, {1, 8}, {1, 9}, {2, 6}, {2, 7}, {2, 8}, {3, 7}, {3, 8}, {3, 9}}
	n, s, t, edges := u.BipartiteMatchingGraph(10, a, b, es)
	f := this.MaxFlowSingle(n, s, t, edges)

	if got, ex := u.BipartiteMatching(a, b, es, f), 4; len(got) != ex {
		test.Errorf("want matching of size %d, got %v", ex, got)
	}
}

func TestMatchingSimple(test *testing.T) {
	a, b := []graph.Id{0, 1, 2}, []graph.Id{3, 4, 5}
	es := [][2]graph.Id{{0, 3}, {0, 4}, {1, 5}, {2, 4}, {2, 5}}
	n, s, t, edges := u.BipartiteMatchingGraph(6, a, b, es)
	f := this.MaxFlowSingle(n, s, t, edges)

	if got, ex := u.BipartiteMatching(a, b, es, f), [][2]graph.Id{{0, 3}, {2, 4}, {1, 5}}; !matchingUnordered(got, ex) {
		test.Error(Errf(got, ex))
	}
}

func TestMatchingNo(test *testing.T) {
	a, b := []graph.Id{0, 1, 2}, []graph.Id{3, 4, 5}
	es := [][2]graph.Id{}
	n, s, t, edges := u.BipartiteMatchingGraph(6, a, b, es)
	f := this.MaxFlowSingle(n, s, t, edges)

	if got, ex := u.BipartiteMatching(a, b, es, f), 0; len(got) != ex {
		test.Errorf("want matching of size %d, got %v", ex, got)
	}
}
