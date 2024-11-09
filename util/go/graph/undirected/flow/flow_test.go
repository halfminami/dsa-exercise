package flow

import (
	"testing"

	. "example/util/graph"
	. "example/util/testutil"
)

func TestFlowSend(t *testing.T) {
	f := BuildFlowNetwork(2, Slice2Edge([][]int{{0, 1, 10}}))

	f.Send(1, 0, 10)
	f.Send(0, 1, 3)

	if got, ex := f.Flow(0, 1), Flow(-7); got != ex {
		t.Error(Errf(got, ex))
	}

	if got, ex := f.Flow(1, 0), Flow(7); got != ex {
		t.Error(Errf(got, ex))
	}

	if got, ex := f.Cap(0, 1), Capacity(10); got != ex {
		t.Error(Errf(got, ex))
	}

	if got, ex := f.Cap(1, 0), Capacity(10); got != ex {
		t.Error(Errf(got, ex))
	}

	if got, ex := f.Residual(0, 1), Flow(17); got != ex {
		t.Error(Errf(got, ex))
	}

	if got, ex := f.Residual(1, 0), Flow(3); got != ex {
		t.Error(Errf(got, ex))
	}
}
