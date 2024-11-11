Edmonds-Karp algorithm
- Input: undirected graph with capacity, set of vertices S for source and T for sink
- Output: flow network with maximum flow

Algorithm
- construct network
- repeat
  - find the shortest augmenting path with BFS
  - send flow

Max-Flow application
- Bipartite matching
  - Input: bipartite graph (A, B), edges
  - Output: maximum matching of edges
- Min-Cut
  - Input: same as Max-Flow
  - Output: minimum weighted set of edges to disconnect S and T
- TODO: Vertex Min-Cut
  - Min-Cut but asked for set of vertices
    edges are unweighted
