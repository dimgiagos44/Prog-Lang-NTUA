import java.util.*;

public interface State {
    public String getString();

    public List<Integer> getQueue();

    public List<Integer> getStack();

    public boolean isFinal();

}        
