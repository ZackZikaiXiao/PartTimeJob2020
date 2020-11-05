function final_x = getx( f, value )
%getx 已知线长求x值
%   f:已知函数
%   value:线的长度
x1 = 0;
x2 = 1;
int_result = 0; %单次计算的线长度
while(abs(int_result - value) > 0.005)
    temp = (x1 + x2)/2;
    left=0;
    right=temp;
    int_result=linelength(f, left, right);
    if int_result-value < 0
        x1 = temp;
    else
        x2 = temp;
    end
end
final_x = temp;

