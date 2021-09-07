(* parsing function that was published on pl1 website *)
fun parse file =
   let
      fun readInt input =
  	     Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  	   (* Open input file. *)
      val inStream = TextIO.openIn file
      val N = readInt inStream
      val M = readInt inStream
      val _ = TextIO.inputLine inStream

        (* Reads lines until EOF and puts them in a list as char lists *)
      fun readLines acc =
         let
            val newLineOption = TextIO.inputLine inStream
         in
            if newLineOption = NONE
            then (rev acc)
            else ( readLines ( explode (valOf newLineOption ) :: acc ))
         end;

      val plane = readLines []
            
   in
   	(N, M, plane)
   end;

fun findUpperLimitOuts arr N M = 
   let 
      fun loop ~1 ~1 acc = acc 
      |   loop i j (validOuts) = 
         let 
            val cellValue = Array2.sub(arr, 0, j)
            val upperLimit = 
               if (cellValue = #"U")
               then true
               else false
            
            val nextIter =
               if j = M-1
               then (~1, ~1)
               else (0, j+1)
            
             val newValidOuts = 
               if upperLimit=false 
               then validOuts
               else ((0, j) :: validOuts)
         in 
            loop (#1 nextIter) (#2 nextIter) newValidOuts
         end;
   in 
       loop 0 0 []
   end;

fun findDownerLimitOuts arr N M = 
   let 
      fun loop ~1 ~1 acc = acc 
      |   loop i j (validOuts) = 
         let 
            val cellValue = Array2.sub(arr, (N-1), j)
            val downerLimit = 
               if (cellValue = #"D")
               then true
               else false
            
            val nextIter =
               if j = M-1
               then (~1, ~1)
               else (N-1, j+1)
            
             val newValidOuts = 
               if downerLimit=false 
               then validOuts
               else ((N-1, j) :: validOuts)
         in 
            loop (#1 nextIter) (#2 nextIter) newValidOuts
         end;
   in 
       loop (N-1) 0 []
   end;

fun findLefterLimitOuts arr N M = 
   let 
      fun loop ~1 ~1 acc = acc 
      |   loop i j (validOuts) = 
         let 
            val cellValue = Array2.sub(arr, i, 0)
            val lefterLimit = 
               if (cellValue = #"L")
               then true
               else false
            
            val nextIter =
               if i = N-1
               then (~1, ~1)
               else (i+1, 0)
            
             val newValidOuts = 
               if lefterLimit=false 
               then validOuts
               else ((i, 0) :: validOuts)
         in 
            loop (#1 nextIter) (#2 nextIter) newValidOuts
         end;
   in 
       loop 0 0 []
   end;


fun findRighterLimitOuts arr N M = 
   let 
      fun loop ~1 ~1 acc = acc 
      |   loop i j (validOuts) = 
         let 
            val cellValue = Array2.sub(arr, i, (M-1))
            val righterLimit = 
               if (cellValue = #"R")
               then true
               else false
            
            val nextIter =
               if i = N-1
               then (~1, ~1)
               else (i+1, M-1)
            
             val newValidOuts = 
               if righterLimit=false 
               then validOuts
               else ((i, M-1) :: validOuts)
         in 
            loop (#1 nextIter) (#2 nextIter) newValidOuts
         end;
   in 
       loop 0 (M-1) []
   end;


fun findValidNeighbors arr (x, y) N M  = 
   let 
      val down = (x+1, y)
      val left = (x, y-1)
      val right = (x, y+1)
      val up = (x-1, y)

      val result1 = 
         if ((#1 up) >= 0) andalso (Array2.sub(arr, x-1, y) = #"D")
         then [up]
         else []
      

      val result2 = 
         if ((#2 right) < M) andalso (Array2.sub(arr, x, y+1) = #"L")
         then right::result1
         else result1 
      
      val result3 = 
         if ((#2 left) >= 0) andalso (Array2.sub(arr, x, y-1) = #"R")
         then left::result2
         else result2
      
      
      val result4 = 
         if ((#1 down) < N) andalso (Array2.sub(arr, x+1, y) = #"U")
         then down::result3
         else result3 
   in 
      result4
   end;

fun   spreader _ _ _  nil result = result
|     spreader arr N M toVisit visited =
         let 
            val h = List.hd toVisit; 
            val neighbors = findValidNeighbors arr h N M; 
            val newVisited = visited + 1;
            val rest = List.tl toVisit;
            val newToVisit = neighbors @ rest;
           
         in 
            spreader arr N M newToVisit newVisited
         end;





fun loop_rooms file = 
   let 
      val out = parse file;
      val N = #1 out;
      val M = #2 out;
      val array  = Array2.fromList (#3 out)
      (* finding at first all output edgy gates *)
      val upGates = findUpperLimitOuts array N M;
      val downGates = findDownerLimitOuts array N M;
      val rightGates = findRighterLimitOuts array N M;
      val leftGates = findLefterLimitOuts array N M;
      val gates = upGates @ downGates @ leftGates @ rightGates;
      (* val gates contains all edgy gates now *)
      
      (* spreading in the grid to find more gats *)
      val result = spreader array N M gates 0;
      (* result is a counter of the existing gates in the grid *)
      val result2 = N*M - result;
      val resultInString = Int.toString(result2)
   in 
     print(resultInString ^ "\n")
    
   end;
