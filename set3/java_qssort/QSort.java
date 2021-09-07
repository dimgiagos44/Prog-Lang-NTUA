import java.io.*;
import java.util.*;
import java.lang.String;

public class QSsort {
    public static void main(String args[]) {
        try {
            BufferedReader in = new BufferedReader(new FileReader(args[0]));
            String line = in.readLine();
            int numbers = Integer.parseInt(line);
            List<Integer> que = new ArrayList<Integer>();
            line = in.readLine();
            String[] a = line.split(" ");
            for (int i = 0; i < numbers; i++) {
                que.add(Integer.parseInt(a[i]));
            }
            in.close();
            List<Integer> stack1 = new ArrayList<Integer>();
            State initial = new QSsortState(que, stack1, "");
            if (initial.isFinal()) {
                System.out.println("empty");

            } else {
                Queue<QSsortState> remaining = new ArrayDeque<>();
                Set<Integer> seen = new HashSet<>();
                int p1;
                int temp = que.remove(0);
                stack1.add(temp);
                remaining.add(new QSsortState(que, stack1, "Q"));
                while (!remaining.isEmpty()) {
                    QSsortState s = remaining.remove();
                    p1 = s.hashCode();
                    if (s.isFinal()) {
                        System.out.println(s.getString());
                        break;
                    }
                    if (!seen.contains(p1)) {
                        seen.add(p1);
                        QSsortState s2 = new QSsortState(s);
                        if (s.getQueue().size() > 1) {
                            Integer tempQ = s.getQueue().remove(0);
                            List<Integer> st2 = s.getStack();
                            st2.add(tempQ);
                            remaining.add(new QSsortState(s.getQueue(), st2, s.getString() + "Q"));
                        }
                        if (!s2.getStack().isEmpty()) {
                            int size = s2.getStack().size() - 1;
                            Integer tempS = s2.getStack().get(size);
                            s2.getStack().remove(size);
                            List<Integer> qu2 = s2.getQueue();
                            qu2.add(tempS);
                            remaining.add(new QSsortState(qu2, s2.getStack(), s2.getString() + "S"));
                        }
                    }
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}        
