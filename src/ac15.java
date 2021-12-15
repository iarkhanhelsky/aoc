import java.io.IOException;
import java.util.ArrayList;
import java.util.Deque;
import java.util.LinkedList;
import java.util.List;

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

        // print(field, h, w);

        System.out.println(score(field));
        System.out.println(score(expand(field, h, w)));
    }

    public static int[][] expand(int[][] field, int h, int w) {
        int h0 = h * 5;
        int w0 = w * 5;
        int[][] exp = new int[h0][w0];

        for(int i = 0; i < 5; i++) {
            for(int j = 0; j < 5; j++) {
                for(int k = 0; k < h; k++) {
                    for(int p = 0; p < w; p++) {
                        exp[i * h + k][j * w + p] = field[i][j] + (i + j);
                    }
                }
            }
        }

        return exp;
    }
    
    public static int score(int[][] field) {
        int h = field.length;
        int w = field[0].length;
        Deque<Point> queue = new LinkedList<>();
        queue.add(new Point(0, 0));
        int[][] score = new int[h][w];

        while(!queue.isEmpty()) {
            Point c = queue.poll(); 
            
            // System.out.println();
            // System.out.println("i: " + c.x + ", j: " + c.y);
            // print(score, h, w);
            
            for(Point n : neighbours(c.x, c.y, h, w)) {
                if (n.x == 0 && n.y == 0) {
                    continue;
                }
                int risk = field[n.x][n.y] + score[c.x][c.y];
                // System.out.println(c.x + "," + c.y + " -> " + n.x + "," + n.y + "   r: " + risk + ", cur: " + score[n.x][n.y]);
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
