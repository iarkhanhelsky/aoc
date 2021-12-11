import java.io.IOException;
import java.util.Deque;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Set;

public class ac11 {
    public record Point(int x, int y) {}
    
    public static void main(String[] args) throws IOException {
        String data = new String(System.in.readAllBytes());
        String[] lines = data.split("\n");
        int[][] field = new int[10][10];

        for(int i = 0; i < lines.length; i++) {
            String line = lines[i];
            for(int j = 0; j < line.length(); j++) {
                field[i][j] = Integer.valueOf(line.charAt(j) + "");
            }
        }

        // int sum = 0;

        // for(int i = 0; i < 200; i++) {
        //     sum += iteration(field, i);
        // }

        int it = 0;
        while(true) {
            int flashed = iteration(field, it);
            if (flashed == 100) {
                System.out.println("All! " + (it + 1));
                System.exit(0);
            }
            it++;
        }
    }

    public static int iteration(int[][] field, int it) {
        increase(field);
        int flashed = flash(field);
        reset(field);
        return flashed;
    }

    public static void increase(int[][] field)
    {
        for(int i = 0; i < field.length; i++)
        {
            for(int j = 0; j < field[i].length; j++)
            {
                field[i][j] += 1;
            }
        }
    }

    public static int flash(int[][] field)
    {
        int w = field.length;
        int h = field[0].length;
        Set<Point> visited = new HashSet<>();
        Deque<Point> queue = new LinkedList<>();

        for(int i = 0; i < field.length; i++) {
            for(int j = 0; j < field[i].length; j++) {
                if (field[i][j] > 9) {
                    queue.add(new Point(i, j));
                }
            }
        }

        while(!queue.isEmpty()) {
            Point curr = queue.poll();
            if (visited.contains(curr))
            {
                continue;
            }
            visited.add(curr);

            int i = curr.x;
            int j = curr.y;

            for(int t = -1; t < 2; t++) {
                for (int u = -1; u < 2; u++) {
                    var i0 = i + t;
                    var j0 = j + u;

                    if (t == 0 && u == 0) {
                        continue;
                    }
                    if (!checkBounds(i0, j0, w, h)) {
                        continue;
                    }

                    field[i0][j0] += 1;
                    if (field[i0][j0] > 9) {
                        queue.add(new Point(i0, j0));
                    }
                }
            }
        }


        return visited.size();
    }

    public static boolean checkBounds(int i, int j, int w, int h) {
        return i >= 0 && i < w && j >= 0 && j < h;
    }

    public static void reset(int[][] field)
    {
        for(int i = 0; i < field.length; i++)
        {
            for(int j = 0; j < field[i].length; j++)
            {
                if (field[i][j] > 9) {
                    field[i][j] = 0;
                }
            }
        }
    }
}
