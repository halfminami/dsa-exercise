package edmondskarp

import (
	"example/util/graph"
	u "example/util/graph/undirected"
	"example/util/graph/undirected/flow"
)

const flowMax flow.Flow = 1010101010

func minRes(path []graph.Id, f flow.FlowNetwork) flow.Flow {
	mn := flowMax

	for i := range len(path) - 1 {
		x, y := path[i], path[i+1]
		mn = min(mn, f.Residual(x, y))
	}

	return mn
}

func send(path []graph.Id, f flow.FlowNetwork, r flow.Flow) {
	for i := range len(path) - 1 {
		x, y := path[i], path[i+1]
		f.Send(x, y, r)
	}
}

func MaxFlowSets(n uint, sources, targets []graph.Id, edges []graph.Edge) (graph.Id, graph.Id, flow.FlowNetwork) {
	s, ns, adds := u.SuperNode(n, sources, graph.Weight(flowMax))
	t, nt, addt := u.SuperNode(ns, targets, graph.Weight(flowMax))

	return s, t, MaxFlowSingle(nt, s, t, append(append(edges, adds...), addt...))
}

// must be source != target
func MaxFlowSingle(n uint, source, target graph.Id, edges []graph.Edge) flow.FlowNetwork {
	f := flow.BuildFlowNetwork(n, edges)

	for {
		path, ok := bfs(source, target, f, func(i1, i2 graph.Id) bool { return f.Residual(i1, i2) > 0 })

		if !ok {
			break
		}

		send(path, f, minRes(path, f))
	}

	return f
}
