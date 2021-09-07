import java.util.*;
import java.io.*;

public class Round {
    public static void main(String[] args) {
        try{

            BufferedReader in = new BufferedReader(new FileReader(args[0]));
            String line = in.readLine();
            String[] a = line.split(" ");
            int N = Integer.parseInt(a[0]);
            int K = Integer.parseInt(a[1]);

            String line2 = in.readLine();
            String[] tokens = line2.split(" ");
            int[] cars = new int[tokens.length];

            
            for (int i=0; i<cars.length;i++){
                cars[i] = Integer.parseInt(tokens[i]);
            }

    

            State[] states = new State[N];
            for (int i=0; i<N; i++){
                states[i] = findMaxSum(i, cars, N);
            }


            List<State> statesList = Arrays.asList(states);
            
            Collections.sort(statesList);

            int max, sum, city, resSum=-1, resCity=-1;
            for (int i=0; i<N; i++){
                max = statesList.get(i).max;
                sum = statesList.get(i).sum;
                city = statesList.get(i).city;
                if (max-(sum-max) < 2){
                    resSum = sum;
                    resCity = city;
                    break;
                }
            }

            System.out.println(resSum + " " + resCity);
            
        }
        catch (IOException e){
            System.out.println("Please provide an input file.");
          }
    }

    public static State findMaxSum(int city, int[] cars, int N){
        int max = 0;
        int sum = 0;
        for(int i=0; i<cars.length; i++){
            if (cars[i] > city){
                max = Math.max(max, N-cars[i]+city);
                sum = sum + N - cars[i] + city;
            }
            else if (cars[i] < city){
                max = Math.max(max, city-cars[i]);
                sum = sum + city - cars[i];
            }
            else{
                continue;
            }
        }
        State info = new State(max, sum, city);
        return info;
    }

}

class State implements Comparable<State>{
    int max;
    int sum;
    int city;
    State(int m, int s, int c){
        max = m;
        sum = s;
        city = c;
    }


    @Override
    public int compareTo(State o) {
        return this.sum - o.sum;
    }
} 
