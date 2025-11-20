#include <stdio.h>

int max_sum_col_index(int *a, int rows, int cols)
{
    int i, j;
    int max_col = 0;
    int max_sum = 0;
    int sum;

    for (j = 0; j < cols; j++) {
        sum = 0;
        for (i = 0; i < rows; i++) {
            sum = sum + a[i * cols + j];
        }
        if (j == 0 || sum > max_sum) {
            max_sum = sum;
            max_col = j;
        }
    }

    return max_col;
}


int main(void)
{
    int m[4][4] = {
        {  1,  2,  3,  4 },
        {  5,  6,  7,  8 },
        {  9, 10, 11, 12 },
        { 13, 14, 15, 16 }
    };

    int idx = max_sum_col_index(&m[0][0], 4, 4);

    printf("%d\n", idx);

    return 0;
}
