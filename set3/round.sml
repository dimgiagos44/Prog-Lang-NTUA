fun parse file =
   let
      fun readInt input =
  	     Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  	  (* Open input file. *)
      val inStream = TextIO.openIn file;
      (* Read K,N,Q and consume newline. *)
  	    val N = readInt inStream;
        val K = readInt inStream;
        val _ = TextIO.inputLine inStream;

        fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
      	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)

        val cars = readInts K [];
    in
   	    (N, K, cars)
   end;




fun round file = 
        let 
            fun check2 x = 
                let
                    val (sum, max, city) = x;
                    val diff = sum - max;
                    val diff2 = max - diff;
                in 
                    if (diff2 < 2) then true 
                    else false
                end;

            fun findDist [] city sum max _ = (sum, max, city)
            |   findDist (x::xs) city sum max N =
                    if (x > city) then findDist xs city (sum + N - x + city) (Int.max(max, N-x+city)) N
                    else if (x = city) then findDist xs city sum max N
                    else findDist xs city (sum + city - x) (Int.max(max, city-x)) N
                

            fun createCities N = List.tabulate(N, fn x => x)

            fun generateSolutions xs N = 
                let 
                    
                    val cities = createCities N;
                    val res =  List.map (fn x => findDist xs x 0 0 N) cities;
                in 
                    res
                end;

            fun check3 (x::xs) = if (check2 x) then x else check3 xs

            fun mergeSort nil = nil 
            |   mergeSort [a] = [a]
            |   mergeSort list = 
                    let 
                        fun halve nil = (nil, nil)
                        |   halve [a] = ([a], nil)
                        |   halve (a::b::cs) = 
                                let 
                                    val (x, y) = halve cs;
                                in 
                                    (a::x, b::y)
                                end;
                        
                        fun merge (nil, nil) = nil
                        |   merge (nil, restb) = restb
                        |   merge(resta, nil) = resta
                        |   merge (a::resta, b::restb) = 
                                let 
                                    val (suma, maxa, citya) = a;
                                    val (sumb, maxb, cityb) = b
                                in 
                                    if (suma > sumb)
                                    then b :: merge(a::resta, restb)
                                    else a :: merge(resta, b::restb)
                                end;
                                

                        val (x, y) = halve(list);
                    in 
                        merge (mergeSort(x), mergeSort(y))
                    end;

            val out = parse file;
            val N = #1 out;
            val K = #2 out;
            val xs = #3 out;
            val solutions = generateSolutions xs N;
            val sortedSolutions = mergeSort solutions;
            val (totalMoves, _, lastCity) = check3 sortedSolutions;
        in 
            
            print(Int.toString(totalMoves) ^ " " ^ Int.toString(lastCity) ^ "\n")
        end; 
