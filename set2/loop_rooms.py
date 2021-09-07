import sys

class UnionFind:
    """Weighted quick-union with path compression and connected components.
    The original Java implementation is introduced at
    https://www.cs.princeton.edu/~rs/AlgsDS07/01UnionFind.pdf
    >>> uf = UnionFind(10)
    >>> for (p, q) in [(3, 4), (4, 9), (8, 0), (2, 3), (5, 6), (5, 9),
    ...                (7, 3), (4, 8), (6, 1)]:
    ...     uf.union(p, q)
    >>> uf._id
    [8, 3, 3, 3, 3, 3, 3, 3, 3, 3]
    >>> uf.find(0, 1)
    True
    >>> uf._id
    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
    """

    def __init__(self, n):
        self._id = list(range(n))
        self._sz = [1] * n
        self.cc = n  # connected components

    def _root(self, i):
        j = i
        while (j != self._id[j]):
            self._id[j] = self._id[self._id[j]]
            j = self._id[j]
        return j

    def find(self, p, q):
        return self._root(p) == self._root(q)

    def union(self, p, q):
        i = self._root(p)
        j = self._root(q)
        if i == j:
            return
        if (self._sz[i] < self._sz[j]):
            self._id[i] = j
            self._sz[j] += self._sz[i]
        else:
            self._id[j] = i
            self._sz[i] += self._sz[j]
        self.cc -= 1

inputFile = open(sys.argv[1])
arr = inputFile.read().split('\n')[:-1]
grid = arr[1:]
dimensions = arr[0].split()
N = dimensions[0]
M = dimensions[1]
#print(N, M)
N = int(N)
M = int(M)

gates = []
ground = 0
uf = UnionFind((N+1)*(M+1))

for j in range(0, M):
    if grid[0][j] == 'U':
        gates.append([0, j])
        uf.union(ground, 0*M + j+1)


for j in range(0, M):
    if grid[N-1][j] == 'D':
        gates.append([N-1, j])
        uf.union(ground, (N-1)*M + j+1)



for i in range(0, N):
    if grid[i][0] == 'L':
        gates.append([i, 0])
        uf.union(ground, i*M + 1)


for i in range(0, N):
    if grid[i][M-1] == 'R':
        gates.append([i, M-1])
        uf.union(ground, i*M + M)

#print(len(gates))

for i in range(0, N):
    for j in range(0, M):
        if (grid[i][j] == 'U' and (i-1)*M >= 0):
            uf.union(i*M + j+1, (i-1)*M + j+1)
            #print(i*M + j+1, (i-1)*M + j+1)
        elif (grid[i][j] == 'D'):
            uf.union(i*M + j+1, (i+1)*M + j+1)
            #print(i*M + j+1, (i+1)*M + j+1)
        elif (grid[i][j] == 'L' and i >= 0 and j > 0):
            uf.union(i*M + j+1, i*M + j)
            #print(i*M + j+1, i*M + j)
        elif (grid[i][j] == 'R' and j < M-1):
            uf.union(i*M + j+1, i*M + j+2)
            #print(i*M + j+1, i*M + j+2)


counter = 0

for i in range(1, N*M + 1):
    if (uf.find(ground, i) == True):
            counter = counter + 1

print(N*M - counter)
#print(grid)
