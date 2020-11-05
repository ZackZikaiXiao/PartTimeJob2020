%%读取
[x_raw, y_raw] = textread('.\NACA0010.txt', '%f %f')
%%整理成100个x（文件中有200个）
x_mask(1:length(x_raw)) = 1;
y_mask(1:length(y_raw)) = 1;
for i=1:length(x_mask)
    if mod(i,2)==0
        x_mask(i)=0;
    end
end
for i=1:length(y_mask)
    if mod(i,2)==0
        y_mask(i)=0;
    end
end
x_raw(x_mask==0)=[];
y_raw(y_mask==0)=[];
y_raw=y_raw./x_raw(end);
x_raw=x_raw./x_raw(end);
clear i x_mask y_mask;

%% define your parameters
a = 0.051;  % amplitude
n = 1.1;
Sp = 1; % Sp is phase velocitya
b = 1.1;
T = 1/(b*Sp);
t = 3/8*T;

ax_low = 0; % x轴左极限
ax_up = 1;  % x轴右极限
ay_low = -0.2;  % y轴左极限
ay_up = 0.2;    % y轴右极限

%% 求出限定的弯曲中轴线的x_max
syms x;  %自变量
x_max1 = 0.6;   %搜索域，越小搜索越快
x_max2 = 1.2;
int_result = 0;
while(abs(int_result - 1) > 0.001)
    x_max = (x_max1 + x_max2)/2;
    f=((2*a*x*sin(2*b*pi*(x - Sp*t)) + 2*a*b*x^2*pi*cos(2*b*pi*(x - Sp*t)))^2 + 1)^(1/2);   %求线长
    left=0;
    right=x_max;
    int_result=double(combinefuc(f, left, right));    
    if int_result-1 < 0
        x_max1 = x_max;
    else
        x_max2 = x_max;
    end
end
clear x_max1 x_max2 x left right int_result f

%%生成绘图坐标
syms x;
f = a*x^2*sin(2*pi*b*(x -Sp*t)); % 论文方程(1)
draw_x = 0:1/100:x_max;
draw_y = a*draw_x.^2.*sin(2*pi*b*(draw_x -Sp*t));
draw_x = [draw_x draw_x];
draw_y=[draw_y draw_y];
f_d = diff(f, x);

%%添加偏置
flagup = 1;     %搜寻标志，减少搜索空间
flagdown = 101;
%%(1)轴上方时
for i=1:100     %对于每一个点
    k = double(subs(f_d, x, draw_x(i)));    %斜率
    %(1.1)斜率大于0时
    if k>0 
        linelength = double(int(sqrt(1+diff(f, x)^2),0,draw_x(i)));
        for j=flagup:100
            if x_raw(j)>linelength
                flagup = j;
                l=y_raw(j);
                break
            end
        end
        sita = atan(k);
        draw_x(i) = draw_x(i) - l*sin(sita);
        draw_y(i) = draw_y(i) + l*cos(sita);
    end
    %(1.2)斜率小于0时
    if k<0
        linelength = double(int(sqrt(1+diff(f, x)^2),0,draw_x(i)));
        for j=flagup:100
            if x_raw(j)>linelength
                flagup = j;
                l=y_raw(j);
                break
            end
        end
        sita = atan(-k);
        draw_x(i) = draw_x(i) + l*sin(sita);
        draw_y(i) = draw_y(i) + l*cos(sita);
    end
end   
        

%%(2)轴下方时
for i=101:200     %对于每一个点
    k = double(subs(f_d, x, draw_x(i)));    %斜率
    %(2.1)斜率大于0时
    if k>0
        linelength = double(int(sqrt(1+diff(f, x)^2),0,draw_x(i)));
        for j=flagdown:200
            if x_raw(j)>linelength
                flagup = j;
                l=-y_raw(j);
                break
            end
        end
        sita = atan(k);
        draw_x(i) = draw_x(i) + l*sin(sita);
        draw_y(i) = draw_y(i) - l*cos(sita);
    end
    %(2.2)斜率小于0时
    if k<0
        linelength = double(int(sqrt(1+diff(f, x)^2),0,draw_x(i)));
        for j=flagdown:200
            if x_raw(j)>linelength
                flagup = j;
                l=-y_raw(j);
                break
            end
        end
        sita = atan(-k);
        draw_x(i) = draw_x(i) - l*sin(sita);
        draw_y(i) = draw_y(i) - l*cos(sita);
    end
end   


plot(draw_x(1:100),draw_y(1:100), 'Color', [0 0 0]);
hold on;
plot(draw_x(101:200),draw_y(101:200),  'Color', [0 0 0]);
hold on;
x_stand=0:1/100:x_max;
y_stand = a*x_stand.^2.*sin(2*pi*b*(x_stand -Sp*t));
plot(x_stand,y_stand, 'Color', [1 0 0]);
hold on;
axis([ax_low ax_up ay_low ay_up]);
clear;
clc;