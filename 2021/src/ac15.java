import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Queue;

public class ac15 {
    public record Point(int x, int y) {}

    public static void main(String[] args) throws IOException {
        String data = new String(System.in.readAllBytes());
        String[] lines = data.split("\n");
        int h = lines.length;
        int w = lines[0].length();
        int[][] field = new int[lines.length][lines[0].length()];
        for(int i = 0; i < lines.length; i++) {
            for(int j = 0; j < lines[i].length(); j++) {
                field[i][j] = lines[i].charAt(j) - '0';
            }
        }

        checkExpand();
        System.out.println("CheckExpand() OK");
        // System.out.println(score(field));
        // System.out.println(score(expand(field, h, w)));

        System.out.println(socreAStar(field));
        System.out.println(socreAStar(expand(field, h, w)));
    }

    public static void checkExpand() {
        int[][] testField = new int[][] {
            { 8},
        };

        int[][] expanded = new int[][]  {
            {8, 9, 1, 2, 3}, 
            {9, 1, 2, 3, 4},
            {1, 2, 3, 4, 5},
            {2, 3, 4, 5, 6},
            {3, 4, 5, 6, 7}
        };

        int[][] test = expand(testField, 1, 1);
        for(int i = 0; i < expanded.length; i++) {
            for(int j = 0; j < expanded.length; j++) {
                if (test[i][j] != expanded[i][j]) {
                    throw new RuntimeException("Failed at " + i + ", " + j);
                }
            }
        }
    }

    public static int[][] expand(int[][] field, int h, int w) {
        int h0 = h * 5;
        int w0 = w * 5;
        int[][] exp = new int[h0][w0];

        for(int i = 0; i < 5; i++) {
            for(int j = 0; j < 5; j++) {
                for(int k = 0; k < h; k++) {
                    for(int p = 0; p < w; p++) {
                        int r = (field[k][p] + (i + j));
                        if (r > 9) {
                            r -= 9;
                        }
                        exp[i * h + k][j * w + p] = r;
                    }
                }
            }
        }

        return exp;
    }

    public static int socreAStar(int[][] field) {
        int h = field.length;
        int w = field[0].length;
        int[][] scored = new int[h][w];
        
        Queue<Point> queue = new PriorityQueue<>(Comparator.comparing((p) -> scored[p.x][p.y] + (h - p.x  + w - p.y)));
        queue.add(new Point(0, 0));

        while(!queue.isEmpty()) {
            Point p = queue.poll();
            
            if (p.x == h - 1 && p.y == w - 1) {
                return scored[h - 1][w - 1];
            } 

            for (Point n : neighbours(p.x, p.y, h, w)) {
                int risk = scored[p.x][p.y] + field[n.x][n.y];

                if (scored[n.x][n.y] == 0 || scored[n.x][n.y] > risk) {
                    scored[n.x][n.y] = risk;
                    queue.add(n);
                }
            }
        }

        return -1;
    }

    public static int score(int[][] field) {
        int h = field.length;
        int w = field[0].length;
        Deque<Point> queue = new LinkedList<>();
        queue.add(new Point(0, 0));
        int[][] score = new int[h][w];

        Point[] neighbours = new Point[4];

        while(!queue.isEmpty()) {
            Point c = queue.poll(); 
            
            for(Point n : neighbours(c.x, c.y, h, w)) {
                if (n == null) {
                    continue;
                }

                if (n.x == 0 && n.y == 0) {
                    continue;
                }

                int risk = field[n.x][n.y] + score[c.x][c.y];
                if (score[n.x][n.y] == 0 || score[n.x][n.y] >= risk) {
                    score[n.x][n.y] = risk;
                    queue.add(n);
                }
            }
        }

        return score[h - 1][w - 1];
    }

    private static void print(int[][] score, int h, int w)
    {
        for(int i = 0; i < h; i++) {
            for(int j = 0; j < w; j++) {
                System.out.print(score[i][j] + ",");
            }
            System.out.println();
        }
    }

    public static List<Point> neighbours(int i, int j, int h, int w) {
        List<Point> points = new ArrayList<>();
        
        if (i > 0) points.add(new Point(i - 1, j));
        if (j > 0) points.add(new Point(i, j - 1));
        if (i + 1 < h) points.add(new Point(i + 1, j));
        if (j + 1 < w) points.add(new Point(i, j + 1));

        return points;
    }
}
