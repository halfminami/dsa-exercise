package flow

import (
	. "example/util/graph"
	internal "example/util/graph/internal"
	"example/util/graph/undirected"
)

type (
	Capacity int
	Flow     Capacity
)

type FlowNetwork interface {
	Cap(Id, Id) Capacity
	Flow(Id, Id) Flow
	Residual(Id, Id) Flow
	Send(Id, Id, Flow)

	Graph
}

type flowNetwork struct {
	flow []map[Id]Flow
	Graph
}

func (fn flowNetwork) Flow(x, y Id) Flow     { return fn.flow[x][y] }
func (fn flowNetwork) Cap(x, y Id) Capacity  { return Capacity(fn.Weight(x, y)) }
func (fn flowNetwork) Residual(x, y Id) Flow { return Flow(fn.Cap(x, y)) - fn.flow[x][y] }

// please don't send too much
func (fn flowNetwork) Send(x, y Id, f Flow) {
	fn.flow[x][y] += f
	fn.flow[y][x] -= f
}

func BuildFlowNetwork(size uint, edges []Edge) FlowNetwork {
	flow := internal.MakeAdjacencyMap[Flow, Id](size)
	graph := undirected.BuildGraph(size, edges)
	return flowNetwork{flow, graph}
}
