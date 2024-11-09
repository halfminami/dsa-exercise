// graph definition

package graph

type (
	Id     uint
	Weight int
)

// 0 <= id < n
type Edge struct {
	X, Y Id
	C    Weight
}

// no validation!
func Slice2Edge(l [][]int) []Edge {
	r := make([]Edge, len(l))

	for i, tup := range l {
		r[i].X = Id(tup[0])
		r[i].Y = Id(tup[1])
		r[i].C = Weight(tup[2])
	}

	return r
}

type Node Id

// (directed) graph
type Graph interface {
	Size() uint
	Neighbor(Id) []Id
	Weight(Id, Id) Weight
}
