import java.io.*;
import java.util.Random;

public class QuickSort
{
    /* function that consider last element as pivot,  
place the pivot at its exact position, and place  
smaller elements to left of pivot and greater  
elements to right of pivot.  */
    int partition (int a[], int start, int end)
    {
        int pivot = a[end]; // pivot element
        int i = (start - 1);

        for (int j = start; j <= end - 1; j++)
        {
            // If current element is smaller than the pivot
            if (a[j] < pivot)
            {
                i++; // increment index of smaller element
                int t = a[i];
                a[i] = a[j];
                a[j] = t;
            }
        }
        // swap a[i+1] and a[end] (or pivot)
        int t = a[i+1];
        a[i+1] = a[end];
        a[end] = t;
        return (i + 1);
    }

    /* function to implement quick sort */
    void quick(int a[], int start, int end) /* a[] = array to be sorted, start = Starting index, end = Ending index */
    {
        if (start < end)
        {
            // p is partitioning index, arr[p] is now at right place
            int p = partition(a, start, end);
            // Recursively sort elements before and after partition
            quick(a, start, p - 1);
            quick(a, p + 1, end);
        }
    }


    public static void main(String[] args) {
        int[] A = new int[1000];//muuta tästä taulukon kokoa
        Random satu = new Random();
        for (int i = 1; i < 1000; i = i+1)//muista syöttää taulukon koko
            A[i] = satu.nextInt(30000000);
        int n = A.length;
        QuickSort q1 = new QuickSort();

        long alkuaika = System.currentTimeMillis();

        q1.quick(A, 0, n - 1);

        long loppuaika = System.currentTimeMillis();

        float sekuntit = Float.valueOf(loppuaika-alkuaika)/1000;

        System.out.println("Elapsed time: " + (loppuaika - alkuaika) + "ms");
        System.out.println("In seconds: " + sekuntit);
    }
}  