#include <stdio.h>
#define M 60

int main()
{
    int a[M], b[M], c[M], d[M];
    for (int i = 0; i < M; i++)
    {
        if (i == 0)
        {
            a[i] = 0;
            b[i] = 1;
        }
        else
        {
            a[i] = a[i - 1] + i;
            b[i] = b[i - 1] + 3 * i;
        }
        c[i] = (i < 20) ? a[i] : ((i < 40) ? a[i] + b[i] : a[i] * b[i]);
        d[i] = (i < 20) ? b[i] : ((i < 40) ? a[i] * c[i] : c[i] * b[i]);
    }

    return 0;
}
