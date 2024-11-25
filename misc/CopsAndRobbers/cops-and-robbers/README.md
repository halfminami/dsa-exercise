A failed attempt for solving Cops and Robbers graph game in $n^{O(k)}$ time.

- Cops can place on at most k vertices at the same time
- in one turn:
  - Robber can move along edges indefinitely
  - Cops can
    - place on some set of vertices, or
    - remove from some set of vertices where cops are put
- Cops and robber can see their opponent's whereabouts
- Cops win if can place on the same vertex as robber is on
