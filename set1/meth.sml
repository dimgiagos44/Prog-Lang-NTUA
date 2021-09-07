(*Help with the algorithm from https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x-set-2/*)

fun readint(infile : string) =
  let
    val ins = TextIO.openIn infile
    fun loop ins = case TextIO.scanStream( Int.scan StringCvt.DEC) ins of
         SOME int => int :: loop ins
        | NONE => []
  in
      loop ins before TextIO.closeIn ins
  end;

exception Empty;

fun sub([],n ) = []
    | sub(x::y, n) = (x - n)::sub(y, n);

fun mult([],n ) = []
    | mult(x::y, n) = (x * n)::mult(y, n);

fun prefixSum (sums, []) = sums
    |   prefixSum ([], x::l) = prefixSum ([x],l)
    |   prefixSum (y::k, x::l) = prefixSum ((x+y)::y::k,l);

fun find_minim (minim, []) = minim 
    |	find_minim ([], x::l) = find_minim([x], l)
    |	find_minim (y::k, x::l) = if (y < x) then find_minim(y::y::k, l)
                                    else find_minim(x::y::k, l);

fun find_maxim (maxim, []) = maxim 
    |	find_maxim ([], x::l) = find_maxim([x], l)
    |	find_maxim (y::k, x::l) = if (y > x) then find_maxim(y::y::k, l)
                                    else find_maxim(x::y::k, l);


 fun maxDiff (l,[],i,j,maxx,n) = if j = n then Int.max(maxx,j-i)
                                 else maxx
    | maxDiff ([],k,i,j, maxx,n) = maxx
    | maxDiff (x::l, y::k, i, j, maxx,n) = if (x < y) then maxDiff(x::l, k, i, j+1, Int.max(maxx,j-i),n)
     								   	   else maxDiff(l,y::k,i+1,j,maxx,n); 

fun longest (infile : string) =
    let
        val input = readint(infile : string);
        val days = hd input;
        val list = tl input;
        val hospital = hd list;
        val arr = sub(mult(tl list,~1) ,hospital);
        val arr2 = rev (prefixSum ([], arr)); 
        val arr3 = (prefixSum ([], arr));
        val LMin = rev (find_minim([], arr2));
        val RMax = find_maxim ([], arr3);
        val result = maxDiff(LMin, RMax, 0, 0, ~1, days);
        val res = Int.toString(result); 
        val a = Int.toString(days)
        
    in 
        print(res ^ "\n")
    end;        
