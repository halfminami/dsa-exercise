package internal

func MakeAdjacencyList[T any](size uint) [][]T {
	r := make([][]T, size)

	for i := range r {
		r[i] = make([]T, 0)
	}

	return r
}

func MakeAdjacencyMap[T any, Id comparable](size uint) []map[Id]T {
	r := make([]map[Id]T, size)

	for i := range r {
		r[i] = make(map[Id]T)
	}

	return r
}
