% [x, y] = textread('D:\Zack\Desktop\visual\NACA0010.txt', '%f %f')
%% define variables
a = 0.051;  % amplitude
n = 1.1;
Sp = 1; % Sp is phase velocitya
b = 1.0;
T = 1/(b*Sp);
t = [1/8*T, 2/8*T, 3/8*T, 4/8*T];

ax_low = 0; % x轴左极限
ax_up = 1;  % x轴右极限
ay_low = -0.2;  % y轴左极限
ay_up = 0.2;    % y轴右极限


for t_instant = t
    %% calculate the value of t_max
    x = 0;
    t_max1 = 0.01;
    t_max2 = 1.5;
    int_result = 0;
    while(abs(int_result - 1) > 0.01)
        t_max = (t_max1 + t_max2)/2;
        %%int_result计算代码段
        %     syms x f t_max a n Sp b t ;
        % y = a*x^2*sin(2*pi*b*(x -Sp*t));
        % f = sqrt(1+power(diff(y, x), 2));
%         int_result = double(int(((2*a*x*sin(2*b*pi*(x - Sp*t_instant)) + 2*a*b*x^2*pi*cos(2*b*pi*(x - Sp*t_instant)))^2 + 1)^(1/2), 0, t_max));
        %%integrate
        f=((2*a*x*sin(2*b*pi*(x - Sp*t_instant)) + 2*a*b*x^2*pi*cos(2*b*pi*(x - Sp*t_instant)))^2 + 1)^(1/2);
        left=0;
        right=t_max;
        int_result=combinefuc(f, left, right);    
        if int_result-1 < 0
            t_max1 = t_max;
        else
            t_max2 = t_max;
        end
    end

    % calculate the function
    x=0:1/100:t_max;
    y = a*x.^2.*sin(2*pi*b*(x -Sp*t_instant));
    % y = a*power(x,n)*sin(2*pi*b*(x-Sp*t));
    plot(x,y);
    axis([ax_low ax_up ay_low ay_up]);
    hold on
end
    clc 
    clear
