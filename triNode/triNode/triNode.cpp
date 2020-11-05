#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string.h>
#define _GNU_SOURCE
#define MAXNUM 100
using namespace std;


int my_getline(char* line, int max_size)
{
    int c;
    int len = 0;
    while ((c = getchar()) != EOF && len < max_size) {
        line[len++] = c;
        if ('\n' == c)
            break;
    }


    line[len] = '\0';
    return len;
}

typedef struct
{
    int i, j;//行，列
    float e;//值
}Tripe;
typedef struct
{
    Tripe data[1000];//三元组表数组
    int rpos[MAXNUM];
    int mu, nu, tu;//行数，列数，非零元个数
}TSMatrix;
int InitMatrix(TSMatrix& M, int& hang, int& ss, int& lie)//矩阵输入初始化
{
    char* p, shuzi[MAXNUM], sz = 0;
    size_t size;
    //char s[100];
    char fuzhu[20] = " ";//辅助数组，用于存放一个数字的字符串
    int i = 0, count[MAXNUM] = { 0 }, num = 0, j = 0, c = 0, q;
    float final[100] = { 0 };

    //getline(&s, &size, stdin);
    int len;
    int max_size = 1024;
    char* s = (char*)malloc(sizeof(char) * max_size);
    len = my_getline(s, max_size);
 



    //    cout<<"Input:"<<s<<"\n";
    for (p = s; *p != '\n'; p++)//回车表示1行结束
    {
        if (*p == 32) num++;//当输入一个空格时，每行元素个数+1
        else if ((*p >= '0' && *p <= '9') || *p == '.' || *p == '-')
        {
            count[num]++;//统计每个数的位数
            shuzi[sz] = *p;//存储每个非空格字符
            sz++;
        }
        else if (*p == '#') return 1;//遇到'#'输入结束
    }
    M.nu = num + 1;//存储列数
    lie = num + 1;//返回的列数，用于判断矩阵的正确性
    for (i = 0; i <= num; i++)
    {
        for (j = 0; j < count[i]; j++)
        {
            fuzhu[j] = shuzi[c];
            c++;
        }
        final[i] = float(atof(fuzhu));//将字符串转化为长整型，可用float强制转换，final数组存储每一个分离出来的数
        for (q = 0; q < 20; q++)
        {
            fuzhu[q] = ' ';//每做完一次转化，就要把辅助数组清空
        }
        if (final[i] != 0)
        {
            M.data[ss].e = final[i];//将每一行的非零元都存储到三元组表中
            M.data[ss].i = hang;
            M.data[ss].j = i + 1;
            ss++;//把已存的非零元个数用ss返回
            M.tu++;
        }
    }
    M.mu = hang;//存储行数
    hang++;//每输入一行，行数+1
    return 0;//每次输入一行返回0
}
void PrintfMatrix(TSMatrix M, int num)//打印矩阵
{
    int x, y;
    for (x = 1; x <= M.mu; x++)
    {
        for (y = 1; y <= M.nu; y++)
        {
            if ((M.data[num].i == x) && (M.data[num].j == y))//按行列依次打印
            {
                printf("%-7.2f", M.data[num].e);//输出非零元
                num++;
            }
            else
                printf("%-7d", 0);//输出0元
        }
        printf("\n");
    }
}
void DestoryMatrix(TSMatrix& M)//矩阵清空
{
    int x;
    M.mu = 0;
    M.nu = 0;
    for (x = 0; x <= M.tu; x++)
    {
        M.data[x].e = 0;
        M.data[x].i = 0;
        M.data[x].j = 0;
        M.rpos[x] = 0;
    }
    M.tu = 0;
}
void AddMatrix(TSMatrix M, TSMatrix N, TSMatrix& T)//加法
{
    int p = 0, q = 0;
    float temp;
    T.mu = M.mu;
    T.nu = M.nu;
    T.tu = 0;
    while (p < M.tu && q < N.tu)
    {
        if ((M.data[p].i == N.data[q].i) && (M.data[p].j == N.data[q].j))//当i,j相等时直接相加
        {
            temp = M.data[p].e + N.data[q].e;
            T.data[T.tu].i = M.data[p].i;
            T.data[T.tu].j = M.data[p].j;
            T.data[T.tu].e = temp;
            T.tu++;//每统计一个元素+1
            p++;
            q++;
        }
        if ((((M.data[p].i == N.data[q].i) && (M.data[p].j < N.data[q].j)) || (M.data[p].i < N.data[q].i)) && (p < M.tu && q < N.tu))//当i相等而M.j<N.j或M.i<N.i,T=M
        {
            T.data[T.tu].i = M.data[p].i;
            T.data[T.tu].j = M.data[p].j;
            T.data[T.tu].e = M.data[p].e;
            p++;//加了M的一个值，p指向下一个M的非零元
            T.tu++;
        }
        if ((((M.data[p].i == N.data[q].i) && (M.data[p].j > N.data[q].j)) || (M.data[p].i > N.data[q].i)) && (p < M.tu && q < N.tu))//当i相等而M.j>N.j或M.i>N.i,T=N
        {
            T.data[T.tu].i = N.data[q].i;
            T.data[T.tu].j = N.data[q].j;
            T.data[T.tu].e = N.data[q].e;
            q++;
            T.tu++;
        }
    }
    while (p < M.tu)//将M中剩余的非零元存储下来
    {
        T.data[T.tu].i = M.data[p].i;
        T.data[T.tu].j = M.data[p].j;
        T.data[T.tu].e = M.data[p].e;
        p++;
        T.tu++;
    }
    while (q < N.tu)//将N中剩余的非零元存储下来
    {
        T.data[T.tu].i = N.data[q].i;
        T.data[T.tu].j = N.data[q].j;
        T.data[T.tu].e = N.data[q].e;
        q++;
        T.tu++;
    }
}
void SubtractMatrix(TSMatrix M, TSMatrix N, TSMatrix& T)//减法
{
    int p = 0, q = 0;
    float temp;
    T.tu = 0;
    T.mu = M.mu;
    T.nu = M.nu;
    while (p < M.tu && q < N.tu)
    {
        if ((M.data[p].i == N.data[q].i) && (M.data[p].j == N.data[q].j))//过程与加法类似
        {
            temp = M.data[p].e - N.data[q].e;//直接相减
            T.data[T.tu].i = M.data[p].i;
            T.data[T.tu].j = M.data[p].j;
            T.data[T.tu].e = temp;
            T.tu++;
            p++;
            q++;
        }
        if ((((M.data[p].i == N.data[q].i) && (M.data[p].j < N.data[q].j)) || (M.data[p].i < N.data[q].i)) && (p < M.tu && q < N.tu))
        {
            T.data[T.tu].i = M.data[p].i;
            T.data[T.tu].j = M.data[p].j;
            T.data[T.tu].e = M.data[p].e;
            p++;
            T.tu++;
        }
        if ((((M.data[p].i == N.data[q].i) && (M.data[p].j > N.data[q].j)) || (M.data[p].i > N.data[q].i)) && (p < M.tu && q < N.tu))
        {
            T.data[T.tu].i = N.data[q].i;
            T.data[T.tu].j = N.data[q].j;
            T.data[T.tu].e = 0 - N.data[q].e;//N的值作为减数时，直接取负
            q++;
            T.tu++;
        }
    }
    while (p < M.tu)
    {
        T.data[T.tu].i = M.data[p].i;
        T.data[T.tu].j = M.data[p].j;
        T.data[T.tu].e = M.data[p].e;
        p++;
        T.tu++;
    }
    while (q < N.tu)
    {
        T.data[T.tu].i = N.data[q].i;
        T.data[T.tu].j = N.data[q].j;
        T.data[T.tu].e = 0 - N.data[q].e;
        q++;
        T.tu++;
    }
}
void Count(TSMatrix& T)
{
    int num[MAXNUM] = { 0 };
    int col;
    for (col = 1; col <= T.mu; col++)
        num[col] = 0;
    for (col = 1; col <= T.tu; col++)
        ++num[T.data[col].i];
    T.rpos[1] = 1;
    for (int i = 2; i <= T.mu; i++)
        T.rpos[i] = T.rpos[i - 1] + num[i - 1];
}
int MultiplyMatrix(TSMatrix M, TSMatrix N, TSMatrix& Q)//乘法运算，采用行逻辑链接算法
{
    Count(M);//对M.rpos赋值
    Count(N);//对N.rpos赋值
    if (M.nu != N.mu)//当M的列数与N的行数不相等时，无法进行运算
        return 0;
    Q.mu = M.mu;
    Q.nu = N.nu;
    Q.tu = 0;
    float ctemp[100] = { 0 };
    int arow, tp, p, brow, t, q, ccol;
    if (M.tu * N.tu)
    {
        for (arow = 1; arow <= M.mu; arow++)
        {
            for (int x = 1; x <= N.nu; x++)//当前行各元素累加器清零
                ctemp[x] = 0;
            Q.rpos[arow] = Q.tu + 1;         //  当前行的首个非零元素在三元组中的位置为此行前所有非零元素+1
            if (arow < M.mu)    tp = M.rpos[arow + 1];
            else   tp = M.tu + 1;
            for (p = M.rpos[arow]; p < tp; p++)
            {     //   对当前行每个非零元素进行操作
                brow = M.data[p].j;            //  在N中找到i值也操作元素的j值相等的行
                if (brow < N.mu)    t = N.rpos[brow + 1];
                else    t = N.tu + 1;
                for (q = N.rpos[brow]; q < t; q++)
                {      //  对找出的行当每个非零元素进行操作
                    ccol = N.data[q].j;
                    ctemp[ccol] += M.data[p].e * N.data[q].e;//将乘得到对应值放在相应的元素累加器里面
                }
            }
            for (ccol = 1; ccol <= Q.nu; ccol++)//将运算完的每一行的值存储到Q中
            {
                if (ctemp[ccol])
                {
                    Q.tu++;
                    Q.data[Q.tu].e = ctemp[ccol];
                    Q.data[Q.tu].i = arow;
                    Q.data[Q.tu].j = ccol;
                }
            }
        }
    }
    return 1;//运算成功
}
void TransposeSMatrix(TSMatrix M, TSMatrix& T)//转置
{
    int p, q = 0, col;
    T.mu = M.nu;
    T.nu = M.mu;
    T.tu = M.tu;
    if (T.tu)//T为非空矩阵
    {
        for (col = 1; col <= M.nu; col++)
        {
            for (p = 0; p < M.tu; p++)
            {
                if (M.data[p].j == col)
                {
                    T.data[q].i = M.data[p].j;//行、列、值的交换
                    T.data[q].j = M.data[p].i;
                    T.data[q].e = M.data[p].e;
                    q++;
                }
            }
        }
    }
}

int breaken_flag = 1;
int main()
{
    int i = 0, num = 0, hang = 1, judge[MAXNUM] = { 0 }, s = 0, pd, k = 1;;
    TSMatrix M, N, T, X, Y;
    while (k)
    {
        cout << "请选择要实现的功能：\n1.转置  2.加  3.减  4.乘  0或其他字符.退出\n";
        cin >> k;
        switch (k)
        {
        case 1:
            breaken_flag = 1;
            cout << "你选择了转置功能\n";
            cout << "请输入矩阵(0表示0元,其他数字表示非0元,#号键结束):\n";
            DestoryMatrix(M);//矩阵初始化
            for (i = 0;; i++)
            {
                //                    cout<<"i="<<i<<"\n";
                if (InitMatrix(M, hang, s, num) == 1)//当输入为'#'时，返回1；否则返回0
                {
                    break;  //跳出for循环
                }
                if (breaken_flag == 1) {
                    for (pd = 0; pd <= i; pd++)//判断数组初始化
                    {
                        judge[pd] = 0;
                    }
                    hang = 1;//将之前输入错误矩阵的参数初始化
                    s = 0;
                    num = 0;
                    i = -1;//重新循环，++后i=1
                    DestoryMatrix(M);//对错误矩阵进行清空
                    breaken_flag++;
                }
                else//对输入矩阵的合法性进行判断，下面的输入也多次用到这段代码
                {
                    judge[i] = num;//每输入1行，将该行的列数存储下来
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])//依次与第一行的列数比较，如果不等，提示重新输入
                        {
                            for (pd = 0; pd <= i; pd++)//判断数组初始化
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;//将之前输入错误矩阵的参数初始化
                            s = 0;
                            num = 0;
                            i = -1;//重新循环，++后i=1
                            DestoryMatrix(M);//对错误矩阵进行清空
                            break;
                        }
                    }
                }
            }
            for (pd = 0; pd <= i; pd++)////判断数组置0
            {
                judge[pd] = 0;
            }
            fflush(stdin);//清除输入缓冲区
            printf("你输入的矩阵是：\nA=\n");
            PrintfMatrix(M, 0);//打印矩阵
            printf("开始进行矩阵的转置~\n");
            TransposeSMatrix(M, N);//调用转置函数
            printf("AT=\n");
            PrintfMatrix(N, 0);
            hang = 1;
            s = 0;
            DestoryMatrix(M);//矩阵清空
            DestoryMatrix(N);
            break;
        case 2:
            breaken_flag = 1;
            printf("你选择了矩阵相加\n");
            printf("请输入矩阵(0表示0元,其他数字表示非0元,#号键结束):\n");
            DestoryMatrix(M);//矩阵初始化
            for (i = 0;; i++)
            {
                if (InitMatrix(M, hang, s, num) == 1)//矩阵正确输入完毕
                {
                    break;  //跳出for循环
                }
                if (breaken_flag == 1) {
                    for (pd = 0; pd <= i; pd++)//判断数组初始化
                    {
                        judge[pd] = 0;
                    }
                    hang = 1;//将之前输入错误矩阵的参数初始化
                    s = 0;
                    num = 0;
                    i = -1;//重新循环，++后i=1
                    DestoryMatrix(M);//对错误矩阵进行清空
                    breaken_flag++;
                }
                else
                {
                    judge[i] = num;
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])
                        {
                            for (pd = 0; pd <= i; pd++)
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;
                            s = 0;
                            num = 0;
                            i = -1;
                            DestoryMatrix(M);
                            break;
                        }
                    }
                }
            }
            for (pd = 0; pd <= i; pd++)
            {
                judge[pd] = 0;
            }
            fflush(stdin);
            printf("第1个矩阵是：\nA=\n");
            PrintfMatrix(M, 0);
            hang = 1;
            s = 0;
            DestoryMatrix(N);
            printf("第1个矩阵输入完毕，请输入第2个矩阵\n");
            for (i = 0;; i++)
            {
                if (InitMatrix(N, hang, s, num) == 1)
                {
                    if (M.mu == N.mu && M.nu == N.nu)//判断矩阵是否能进行运算
                    {
                        break;  //跳出for循环
                    }
                    if (breaken_flag == 1) {
                        for (pd = 0; pd <= i; pd++)//判断数组初始化
                        {
                            judge[pd] = 0;
                        }
                        hang = 1;//将之前输入错误矩阵的参数初始化
                        s = 0;
                        num = 0;
                        i = -1;//重新循环，++后i=1
                        DestoryMatrix(M);//对错误矩阵进行清空
                        breaken_flag++;
                    }
                    else
                    {
                        printf("你输入的第2个矩阵行列数与第1个矩阵不同，无法完成运算，请重新输入\n");
                        DestoryMatrix(N);
                        hang = 1;
                        s = 0;
                        num = 0;
                        i = -1;
                    }
                }
                else//进行矩阵合法性的判断
                {
                    judge[i] = num;
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])
                        {
                            for (pd = 0; pd <= i; pd++)
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;
                            s = 0;
                            num = 0;
                            i = -1;
                            DestoryMatrix(N);
                            break;
                        }
                    }
                }
                fflush(stdin);
            }
            fflush(stdin);
            for (pd = 0; pd <= i; pd++)//判断数组置0
            {
                judge[pd] = 0;
            }
            printf("第2个矩阵是：\nB=\n");
            PrintfMatrix(N, 0);//打印第二个矩阵
            printf("开始做加法运算~\n");
            AddMatrix(M, N, T);//进行加法运算
            printf("A+B=\n");
            PrintfMatrix(T, 0);//打印结果
            hang = 1;
            s = 0;
            DestoryMatrix(M);//三元组表清空
            DestoryMatrix(N);
            DestoryMatrix(T);
            break;
        case 3:
            breaken_flag = 1;
            printf("你选择了矩阵相减\n");
            printf("请输入矩阵(0表示0元,其他数字表示非0元,#号键结束):\n");
            DestoryMatrix(M);
            for (i = 0;; i++)
            {
                if (InitMatrix(M, hang, s, num) == 1)
                {
                    break;  //跳出for循环
                }
                if (breaken_flag == 1) {
                    for (pd = 0; pd <= i; pd++)//判断数组初始化
                    {
                        judge[pd] = 0;
                    }
                    hang = 1;//将之前输入错误矩阵的参数初始化
                    s = 0;
                    num = 0;
                    i = -1;//重新循环，++后i=1
                    DestoryMatrix(M);//对错误矩阵进行清空
                    breaken_flag++;
                }
                else
                {
                    judge[i] = num;
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])
                        {
                            for (pd = 0; pd <= i; pd++)
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;
                            s = 0;
                            num = 0;
                            i = -1;
                            DestoryMatrix(M);
                            break;
                        }
                    }
                }
            }
            fflush(stdin);
            for (pd = 0; pd <= i; pd++)//判断数组置0
            {
                judge[pd] = 0;
            }
            printf("第1个矩阵是：\nA=\n");
            PrintfMatrix(M, 0);
            hang = 1;
            s = 0;
            printf("第1个矩阵输入完毕，请输入第2个矩阵\n");
            DestoryMatrix(N);
            for (i = 0;; i++)
            {
                if (InitMatrix(N, hang, s, num) == 1)
                {

                    if (M.mu == N.mu && M.nu == N.nu)
                    {
                        break;  //跳出for循环
                    }
                    if (breaken_flag == 1) {
                        for (pd = 0; pd <= i; pd++)//判断数组初始化
                        {
                            judge[pd] = 0;
                        }
                        hang = 1;//将之前输入错误矩阵的参数初始化
                        s = 0;
                        num = 0;
                        i = -1;//重新循环，++后i=1
                        DestoryMatrix(M);//对错误矩阵进行清空
                        breaken_flag++;
                    }
                    else
                    {
                        printf("你输入的第2个矩阵的行列数与第1个矩阵不同，无法完成运算，请重新输入\n");
                        DestoryMatrix(N);
                        hang = 1;
                        s = 0;
                        num = 0;
                        i = -1;
                    }
                }
                else//进行矩阵合法性的判断
                {
                    judge[i] = num;
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])
                        {
                            for (pd = 0; pd <= i; pd++)
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;
                            s = 0;
                            num = 0;
                            i = -1;
                            DestoryMatrix(N);
                            break;
                        }
                    }
                }
                fflush(stdin);
            }
            fflush(stdin);
            for (pd = 0; pd <= i; pd++)//判断数组置0
            {
                judge[pd] = 0;
            }
            printf("第2个矩阵是：\nB=\n");
            PrintfMatrix(N, 0);
            printf("开始做减法运算~\n");
            SubtractMatrix(M, N, T);//调用减法函数
            printf("A-B=\n");
            PrintfMatrix(T, 0);//打印结果
            hang = 1;
            s = 0;
            DestoryMatrix(M);
            DestoryMatrix(N);
            DestoryMatrix(T);
            break;
        case 4:
            breaken_flag = 1;
            printf("你选择了矩阵相乘\n");
            printf("请输入矩阵(0表示0元,其他数字表示非0元,#号键结束):\n");
            DestoryMatrix(X);
            DestoryMatrix(M);
            for (i = 0;; i++)
            {
                if (InitMatrix(X, hang, s, num) == 1)
                {
                    break;  //跳出for循环
                }
                if (breaken_flag == 1) {
                    for (pd = 0; pd <= i; pd++)//判断数组初始化
                    {
                        judge[pd] = 0;
                    }
                    hang = 1;//将之前输入错误矩阵的参数初始化
                    s = 0;
                    num = 0;
                    i = -1;//重新循环，++后i=1
                    DestoryMatrix(M);//对错误矩阵进行清空
                    breaken_flag++;
                }
                else
                {
                    judge[i] = num;
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])
                        {
                            for (pd = 0; pd <= i; pd++)
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;
                            s = 0;
                            num = 0;
                            i = -1;
                            DestoryMatrix(X);
                            break;
                        }
                    }
                }
            }
            fflush(stdin);
            for (pd = 0; pd <= i; pd++)//判断数组置0
            {
                judge[pd] = 0;
            }
            for (i = 1; i <= X.tu; i++)//由于乘法函数中数组下标为1作为第一个非零元，把三元组表元素依次向后排
            {
                M.data[i].i = X.data[i - 1].i;
                M.data[i].j = X.data[i - 1].j;
                M.data[i].e = X.data[i - 1].e;
            }
            M.mu = X.mu;
            M.nu = X.nu;
            M.tu = X.tu;
            printf("第1个矩阵是：\nA=\n");
            PrintfMatrix(M, 1);
            hang = 1;
            s = 0;
            printf("第1个矩阵输入完毕，请输入第2个矩阵\n");
            DestoryMatrix(Y);
            DestoryMatrix(N);
            for (i = 0;; i++)
            {
                if (InitMatrix(Y, hang, s, num) == 1)//矩阵输入完毕
                {
                    if (M.nu == Y.mu)//可以进行乘法运算
                    {
                        break;  //跳出for循环
                    }
                    if (breaken_flag == 1) {
                        for (pd = 0; pd <= i; pd++)//判断数组初始化
                        {
                            judge[pd] = 0;
                        }
                        hang = 1;//将之前输入错误矩阵的参数初始化
                        s = 0;
                        num = 0;
                        i = -1;//重新循环，++后i=1
                        DestoryMatrix(M);//对错误矩阵进行清空
                        breaken_flag++;
                    }
                    else
                    {
                        printf("你输入的第2个矩阵行数与第1个矩阵的列数不相同，无法完成运算，请重新输入\n");
                        DestoryMatrix(Y);
                        hang = 1;
                        s = 0;
                        num = 0;
                        i = -1;
                    }
                }
                else//判断矩阵行列是否合法
                {
                    judge[i] = num;
                    for (pd = 1; pd <= i; pd++)
                    {
                        if (judge[1] != judge[pd])
                        {
                            for (pd = 0; pd <= i; pd++)
                            {
                                judge[pd] = 0;
                            }
                            printf("你输入的矩阵列数有误，请重新输入\n");
                            hang = 1;
                            s = 0;
                            num = 0;
                            i = -1;
                            DestoryMatrix(Y);
                            break;
                        }
                    }
                }
                fflush(stdin);
            }
            fflush(stdin);
            for (pd = 0; pd <= i; pd++)//判断数组置0
            {
                judge[pd] = 0;
            }
            N.mu = Y.mu;
            N.nu = Y.nu;
            N.tu = Y.tu;
            for (i = 1; i <= Y.tu; i++)
            {
                N.data[i].i = Y.data[i - 1].i;
                N.data[i].j = Y.data[i - 1].j;
                N.data[i].e = Y.data[i - 1].e;
            }
            hang = 1;
            s = 0;
            printf("第2个矩阵是：\nB=\n");
            PrintfMatrix(N, 1);
            printf("开始做乘法运算~\n");
            MultiplyMatrix(M, N, T);//调用乘法函数
            printf("A*B=\n");
            PrintfMatrix(T, 1);//打印矩阵
            hang = 1;
            s = 0;
            DestoryMatrix(M);
            DestoryMatrix(N);
            DestoryMatrix(T);
            DestoryMatrix(X);
            DestoryMatrix(Y);
            break;
        case 0:
            printf("谢谢使用!");
            break;
        default:
            printf("您的输入有误,请重新输入\n");
            break;
        }
    }
}