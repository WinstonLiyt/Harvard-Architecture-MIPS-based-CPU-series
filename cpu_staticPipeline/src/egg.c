#include <stdio.h>

int main()
{
    int ly = 50, q = 36;
    int x = 0, y = 0;
    int l = 0, r = ly + 1, m;

    while (l + 1 != r)
    {
        x++;
        m = (l + r) / 2;
        if (m <= q)
            l = m;
        else
        {
            y++;
            r = m;
        }
        printf("%d ", m);
    }

    printf("\n");
    printf("摔的总次数：%d\n", x);
    printf("摔坏次数：%d\n", y + 1);
    printf("最后一次是否摔坏：%d\n", (r == m));

    return 0;
}
