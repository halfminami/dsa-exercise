package graph

import (
	"fmt"
	"slices"
)

func SlicesEqualUnordered[T any](a, b []T, cmp func(T, T) int, eq func(T, T) bool) bool {
	if len(a) != len(b) {
		return false
	}

	x, y := slices.Clone(a), slices.Clone(b)

	slices.SortFunc(x, cmp)
	slices.SortFunc(y, cmp)

	return slices.EqualFunc(x, y, eq)
}

func Errf[T any](got, ex T) string {
	// you need t.Error in line for the test report
	return fmt.Sprintf("got %v, want %v", got, ex)
}
