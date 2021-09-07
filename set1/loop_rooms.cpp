// Got my efficient Union Find class from here: https://stackoverflow.com/questions/8300125/union-find-data-structure
#include <iostream>
#include <set>
#include <utility>
#include <vector>
#include <fstream>
#include <chrono>
#include <cstdio>
#include <iterator>
#include <bits/stdc++.h>
using namespace std;

vector <pair <pair<int, int>, pair<int, int>>> edges;
set <pair<int, int> > outs;
char grid[1001][1001];


class UF {
        int *id, cnt, *sz;
    public:
        // Create an empty union find data structure with N isolated sets.
        UF(int N) {
            cnt = N; 
            id = new int[N]; 
            sz = new int[N];
            for (int i = 0; i<N; i++)  id[i] = i, sz[i] = 1;
        }

        ~UF() { delete[] id; delete[] sz; }

        // Return the id of component corresponding to object p.
        int find(int p) {
            int root = p;
            while (root != id[root])    root = id[root];
            while (p != root) { int newp = id[p]; id[p] = root; p = newp; }
            return root;
        }
        
        // Replace sets containing x and y with their union.
        void merge(int x, int y) {
            int i = find(x); int j = find(y); if (i == j) return;
            // make smaller root point to larger one
            if (sz[i] < sz[j]) { id[i] = j, sz[j] += sz[i]; }
            else { id[j] = i, sz[i] += sz[j]; }
            cnt--;
        }
        
        // Are objects x and y in the same set?
        bool connected(int x, int y) { return find(x) == find(y); }
        
        // Return the number of disjoint sets.
        int count() { return cnt; }
};

int solver (int N, int M) {

    UF uf(N*M);
    auto it = outs.begin();
    pair<int, int> firstGate = *it;
    int firstGateValue = ((firstGate.first - 1) * M) + (firstGate.second);

    for(auto i: outs){
        int value = ((i.first - 1) * M) + (i.second);
        uf.merge(value, firstGateValue);
    }

    for (int i = 1; i <= N; i++) {
        for (int j = 1; j <= M; j++) {
            char up = grid[i-1][j];
            char down = grid[i+1][j];
            char left = grid[i][j-1];
            char right = grid[i][j+1];
            if (up == 'D'){ 
               
                int value1 = (i-1)*M + j;
                int value2 = ((i-1)-1)*M + j;
                uf.merge(value1, value2);
            }
            if (down == 'U'){   
               
                int value1 = (i-1)*M + j;
                int value2 = ((i+1)-1)*M + j;
                uf.merge(value1, value2);
            }
            if (left == 'R'){  
             
                int value1 = (i-1)*M + j;
                int value2 = (i-1)*M + (j-1);
                uf.merge(value1, value2);
            }
            if (right == 'L'){
              
                int value1 = (i-1)*M + j;
                int value2 = (i-1)*M + (j+1);
                uf.merge(value1, value2);
            }
        }
    }

    int count = 0;
    for (int i = 1; i <= N; i++){
        for (int j = 1; j <= M; j++){
            int value = (i-1)*M + j;
            if (uf.connected(value, firstGateValue)){
                count++;
            }
        }
    }
    
    return N*M - count;
}


int main(int argc, char *argv[]) {

    ifstream inputFile;
    inputFile.open(argv[1]);


    int N, M; //N = rows, M = columns
    inputFile >> N >> M;
    for(int row = 1; row <= N; row++) { 
        for(int column = 1; column <= M; column++){
            inputFile >> grid[row][column]; 
        }
    }
    inputFile.close();

    for (int i = 1; i <= M; i++) {
        if (grid[1][i] == 'U'){
            outs.insert(make_pair(1, i));
        }
        if (grid[N][i] == 'D'){
            outs.insert(make_pair(N, i));
        }
    }

    for (int i = 1; i <= N; i++) {
        if (grid[i][1] == 'L'){
            outs.insert(make_pair(i, 1));
        }
        if (grid[i][M] == 'R'){
            outs.insert(make_pair(i, M));
        }
    }

    int res = solver(N, M);
    cout << res << endl;
    
    return(0);
}                
