function  I  = conbinefuc( f, left, right )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
% left = 0;
% right = 1;
eps = 1.0e-4;

number=1;
h=(right-left)/2;
I1=0;
I2=(subs(sym(f), symvar(sym(f)), left) + subs(sym(f), symvar(sym(f)), right))/h;
while abs(I2-I1)>eps
number=number+1;
h=(right-left)/number;
I1=I2;
I2=0;
for i=0:number-1
    x=left+h*i;
    x1=x+h;
    I2=I2+(h/2)*(subs(sym(f), symvar(sym(f)), x) + subs(sym(f),symvar(sym(f)),x1));
end
end
I=I2;
