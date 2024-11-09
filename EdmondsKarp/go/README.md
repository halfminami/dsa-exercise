Edmonds-Karp algorithm
- Input: undirected graph with capacity, set of vertices S for source and T for sink
- Output: flow network with maximum flow

Algorithm
- construct network
- repeat
  - find the shortest augmenting path with BFS
  - send flow
