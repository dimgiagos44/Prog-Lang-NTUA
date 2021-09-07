from os import stat
from sys import argv
import queue
from copy import deepcopy
from collections import deque
from itertools import groupby

def beg(queue, stack):
    for i in range(0, len(queue)-1):
        if queue[i] > queue[i+1]:
            return False
    return True

filename = argv[1]
file = open(filename,'r')
data = file.readlines()
numbers = int(data[0])
que = data[1].split()
stack = []
for i in range(0,int(data[0])):
    que[i] = int(que[i])

flag = beg(que,[])

grouped_q = [(k, sum(1 for i in g)) for k,g in groupby(que)]
dup = False
for i in range(0, len(grouped_q)):
    if grouped_q[i][1] != 1:
        dup = True
        break

if dup == True:
    q = grouped_q
else:
    q = que


def isFinal1(queue, stack):
    if(queue==0 and stack==0):
        return False
    for i in range(0, len(queue)-1):
        if queue[i][0] > queue[i+1][0]:
            return False
    if not stack:
        return True
    else:
        return False

def isFinal2(queue, stack):
    if(queue==0 and stack==0):
        return False
    for i in range(0, len(queue)-1):
        if queue[i] > queue[i+1]: 
            return False
    if not stack:
        return True
    else:
        return False

def nextState(queue1, stack1,res, state):
    if state == 'Q':
        if queue1:
            temp = queue1.pop(0)
            stack1.append(temp)
            res = res+temp[1]*'Q'
        else:
            return (0,0, res)
    else:
        if(stack1):
            temp = stack1.pop(len(stack1)-1)
            queue1.append(temp)
            res = res+temp[1]*'S'
        else:
            return (0,0, res)
    return (queue1, stack1, res)

def nextState2(queue1, stack1,res, state):
    if state == 'Q':
        if queue1:
            temp = queue1.pop(0)
            stack1.append(temp)
            res = res+'Q'
        else:
            return (0,0, res)
    else:
        if(stack1):
            temp = stack1.pop(len(stack1)-1)
            queue1.append(temp)
            res = res+'S'
        else:
            return (0,0, res)
    return (queue1, stack1, res)
    
if flag == True:
    print("empty")
elif dup == False:
    remaining = deque()
    seen = set()
    temp = q.pop(0)
    stack.append(temp)
    remaining.append((q,stack,'Q'))
    counter = 0 
    while (remaining):     
        s = remaining.popleft()
        if isFinal2(s[0],s[1]):
            print(s[2])
            break
        if (tuple(s[0]),tuple(s[1])) not in seen:
            if (s[0] == 0 and s[1] == 0 ):
                continue
            else:
                seen.add((tuple(s[0]),tuple(s[1]))) 
                s1 = deepcopy(s)
                tmp1 = nextState2(s[0].copy(),s[1].copy(),s[2], 'Q')
                if (tmp1[0] != 0 and tmp1[1] != 0):
                    remaining.append(tmp1)
                tmp2= nextState2(s1[0].copy(), s1[1].copy(), s1[2], 'S')
                if(tmp2[0] != 0 and tmp2[1] != 0):
                    remaining.append(tmp2)
else:
    remaining = deque()
    seen = set()
    temp = q.pop(0)
    stack.append(temp)
    remaining.append((q,stack,temp[1]*'Q'))
    while (remaining):     
        s = remaining.popleft()
        if isFinal1(s[0],s[1]):
            print(s[2])
            break
        if (tuple(s[0]),tuple(s[1])) not in seen:
            if (s[0] == 0 and s[1] == 0 ):
                continue
            else:
                seen.add((tuple(s[0]),tuple(s[1]))) 
                s1 = deepcopy(s)
                tmp1 = nextState(s[0].copy(),s[1].copy(),s[2], 'Q')
                if (tmp1[0] != 0 and tmp1[1] != 0):
                    remaining.append(tmp1)
                tmp2= nextState(s1[0].copy(), s1[1].copy(), s1[2], 'S')
                if(tmp2[0] != 0 and tmp2[1] != 0):
                    remaining.append(tmp2)      
