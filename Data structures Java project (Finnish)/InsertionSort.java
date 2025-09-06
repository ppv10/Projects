import java.io.*;
import java.util.Random;

public class InsertionSort {
    public static void insertionSort(int array[]) {
        int n = array.length;
        for (int j = 1; j < n; j++) {
            int key = array[j];
            int i = j-1;
            while ( (i >= 0) && ( array [i] > key ) ) {
                array [i+1] = array [i];
                i--;
            }
            array[i+1] = key;
        }
    }

    public static void main(String a[]){
        int[] A = new int[1000];//muuta tästä taulukon kokoa
        Random satu = new Random();
        for (int i = 1; i < 1000; i = i+1)//muista muuttaa tähän taulukon koko
            A[i] = satu.nextInt(30000000);

        long alkuaika = System.currentTimeMillis();

        insertionSort(A);

        long loppuaika = System.currentTimeMillis();

        float sekuntit = Float.valueOf(loppuaika-alkuaika)/1000;

        System.out.println("Elapsed time: " + (loppuaika - alkuaika) + "ms");
        System.out.println("In seconds: " + sekuntit);
    }
}