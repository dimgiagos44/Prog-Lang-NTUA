#include <bits/stdc++.h>
#include <iostream>
#include <cstdlib>

//Based on the algorithm and implementation of
//https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/
//and https://www.geeksforgeeks.org/largest-subarray-having-sum-greater-than-k/
using namespace std;

//function to find index using binary search
int binary_search(vector<pair<int, int>> &prefix_Sum, int days, int sum)
{
    int mid, l = 0, h = days - 1, index = INT_MIN;

    while (l <= h)
    {
        mid = (l + h) / 2;
        if (prefix_Sum[mid].first <= sum)
        {
            index = mid;
            l = mid + 1;
        }
        else
            h = mid - 1;
    }

    return index;
}

//function to find longest subarray
pair<int, int> find_longest(int meth[], int hospitals, int days)
{
    int sum = 0, idx = INT_MIN, minimum_index[days];
    vector<pair<int, int>> prefix_Sum;
    pair<int, int> final;
    final.first = 0;
    final.second = 0;

    //subtract x from initial array
    for (int i = 0; i <= days - 1; i++)
        meth[i] -= hospitals;

    //create prefixSum vector with the appropriate index
    for (int i = 0; i <= days - 1; i++)
    {
        sum += meth[i];
        prefix_Sum.push_back({sum, i});
    }

    sort(prefix_Sum.begin(), prefix_Sum.end());

    for (int i = 0; i <= days - 1; i++)
    {
        if (i == 0)
            minimum_index[i] = prefix_Sum[i].second;
        else
            minimum_index[i] = min(prefix_Sum[i].second, minimum_index[i - 1]);
    }

    sum = 0;

    for (int i = 0; i <= days - 1; i++)
    {
        sum += meth[i];
        if (sum < 0)
        {
            idx = binary_search(prefix_Sum, days, sum);
            if (minimum_index[idx] < i)
            {
                if (i - minimum_index[idx] > final.first)
                    final.second = i;
                final.first = max(final.first, i - minimum_index[idx]);
            }
        }
        else
        {
            final.first = i + 1;
            final.second = i;
        }
    }
    return final;
}

int main(int argc, char *argv[])
{

    ifstream myfile(argv[1]);
    int days, hospitals;
    myfile >> days;
    int meth[days];
    myfile >> hospitals;
    for (int i = 0; i < days; i++)
        myfile >> meth[i];

    myfile.close();

    pair<int, int> result;
    for (int i = 0; i <= days - 1; i++)
        meth[i] = meth[i] * (-1);
    result = find_longest(meth, hospitals, days);
    //cout << result.first << endl;
    printf("%d \n", result.first);

    return 0;
}
