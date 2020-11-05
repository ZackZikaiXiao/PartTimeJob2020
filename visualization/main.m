%%��ȡ
[x_raw, y_raw] = textread('.\NACA0010.txt', '%f %f')
%%�����100��x���ļ�����200����
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

ax_low = 0; % x������
ax_up = 1;  % x���Ҽ���
ay_low = -0.2;  % y������
ay_up = 0.2;    % y���Ҽ���

%% ����޶������������ߵ�x_max
syms x;  %�Ա���
x_max1 = 0.6;   %������ԽС����Խ��
x_max2 = 1.2;
int_result = 0;
while(abs(int_result - 1) > 0.001)
    x_max = (x_max1 + x_max2)/2;
    f=((2*a*x*sin(2*b*pi*(x - Sp*t)) + 2*a*b*x^2*pi*cos(2*b*pi*(x - Sp*t)))^2 + 1)^(1/2);   %���߳�
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

%%���ɻ�ͼ����
syms x;
f = a*x^2*sin(2*pi*b*(x -Sp*t)); % ���ķ���(1)
draw_x = 0:1/100:x_max;
draw_y = a*draw_x.^2.*sin(2*pi*b*(draw_x -Sp*t));
draw_x = [draw_x draw_x];
draw_y=[draw_y draw_y];
f_d = diff(f, x);

%%���ƫ��
flagup = 1;     %��Ѱ��־�����������ռ�
flagdown = 101;
%%(1)���Ϸ�ʱ
for i=1:100     %����ÿһ����
    k = double(subs(f_d, x, draw_x(i)));    %б��
    %(1.1)б�ʴ���0ʱ
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
    %(1.2)б��С��0ʱ
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
        

%%(2)���·�ʱ
for i=101:200     %����ÿһ����
    k = double(subs(f_d, x, draw_x(i)));    %б��
    %(2.1)б�ʴ���0ʱ
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
    %(2.2)б��С��0ʱ
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