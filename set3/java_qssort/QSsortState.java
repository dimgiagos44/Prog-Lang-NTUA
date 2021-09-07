import java.util.*;
import java.lang.String;

public class QSsortState implements State {
    // private State previous;
    public List<Integer> s;
    public List<Integer> q;
    public String string;
    public String qstring;
    public String sstring;
    // public String next;

    public QSsortState(List<Integer> qu, List<Integer> st, String S) {
        this.s = st;
        this.q = qu;
        this.string = S;
        // By using String Class
        this.qstring = "";
        this.sstring = "";

        if (!this.q.isEmpty()) {
            Iterator<Integer> iterator = this.q.iterator();
            while (iterator.hasNext()) {
                qstring = qstring + iterator.next();
            }
        }
        // if (!this.s.isEmpty()) {
        // Iterator<Integer> iterator2 = this.s.iterator();
        // while (iterator2.hasNext()) {
        // sstring = sstring + iterator2.next();
        // }
        // }
    }

    public QSsortState(QSsortState another) {
        this.q = new ArrayList<>();
        Iterator<Integer> it = another.q.iterator();
        while (it.hasNext()) {
            Integer q1 = Integer.valueOf(it.next());
            this.q.add(q1);
        }
        this.s = new ArrayList<>();
        Iterator<Integer> it2 = another.s.iterator();
        while (it2.hasNext()) {
            Integer s1 = Integer.valueOf(it2.next());
            this.s.add(s1);
        }
        this.string = another.string;
        // this(another.q.stream().collect(Collectors.toList()), new
        // ArrayList<>(another.s), another.string);
    }

    @Override
    public boolean isFinal() {
        for (int i = 0; i < q.size() - 1; i++) {
            if (q.get(i) > q.get(i + 1)) {
                return false;
            }
        }
        if (s.isEmpty()) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public List<Integer> getStack() {
        return s;
    }

    @Override
    public List<Integer> getQueue() {
        return q;
    }

    @Override
    public String getString() {
        return string;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        QSsortState other = (QSsortState) o;
        return q == other.q && s == other.s;
    }

    @Override
    public int hashCode() {
        return Objects.hash(q, s, qstring);
    }

}        
