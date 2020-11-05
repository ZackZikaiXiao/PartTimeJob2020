% data_load_show = importdata('ysw.mat')
% AT=[];
% AH=[];
% AS=[]; 
% BT=[];
% BH=[];
% BS=[]; 
% CT=[]; 
% CH=[];
% CS=[]; 
% % AT:27.4H:35%S:015mg/L
% single_string_size=21;
% % data_load_show = mat2str(data_load_show);
% % disp(data_load_show)
% cut_size = 200;
% [r, c] = size(data_load_show);
% % 从尾部截取单字符串，判断是哪个传感器的信号
% which_mode='A';
% switch data_load_show(r,c-single_string_size+1)
%     case 'A'
%         which_mode='A';
%     case 'B'
%         which_mode='B';
%     case 'C'
%         which_mode='C';
% end
% % 横坐标
% timercount = 1;
% for i = c-single_string_size+1:1:c
%     disp(data_load_show(r,i))  
%     % 采集到的A的数据
%     if which_mode=='A'
%         if data_load_show(r,i)=='T'
%             AT = [AT str2double(data_load_show(r,i+2:i+5))]
%         end
%         if data_load_show(r,i)=='H'
%             AH = [AH str2double(data_load_show(r,i+2:i+3))]
%         end
%         if data_load_show(r,i)=='S'
%             AS = [AS str2double(data_load_show(r,i+2:i+4))]
%         end
%     end
%     % 采集到的B的数据
%     if which_mode=='B'
%         if data_load_show(r,i)=='T'
%             BT = [BT str2double(data_load_show(r,i+2:i+5))]
%         end
%         if data_load_show(r,i)=='H'
%             BH = [BH str2double(data_load_show(r,i+2:i+3))]
%         end
%         if data_load_show(r,i)=='S'
%             BS = [BS str2double(data_load_show(r,i+2:i+4))]
%         end
%     end
%     % 采集到的C的数据
%     if which_mode=='C'
%         if data_load_show(r,i)=='T'
%             CT = [CT str2double(data_load_show(r,i+2:i+5))]
%         end
%         if data_load_show(r,i)=='H'
%             CH = [CH str2double(data_load_show(r,i+2:i+3))]
%         end
%         if data_load_show(r,i)=='S'
%             CS = [CS str2double(data_load_show(r,i+2:i+4))]
%         end
%     end
% %     disp(data_load_show(r,i))  
% % 
% %     if data_load_show(r,i)=='A'&&i+single_string_size<c
% %         single_string_A = data_load_show(i:i+single_string_size-1);
% %         disp(single_string_A);
% %     end
% %     if data_load_show(r,i)=='B'&&i+single_string_size<c
% %         single_string_B = data_load_show(i:i+single_string_size-1);
% %         disp(single_string_B);
% %     end
% %     if data_load_show(r,i)=='C'&&i+single_string_size<c
% %         single_string_C = data_load_show(i:i+single_string_size-1);
% %         disp(single_string_C);
% %     end
% end
% %%%%%%%作图
% t=-pi:0.5:pi;
% y = sin(t);
% x = 1:1:size(y,2);
% plot(x,y,'b')
% p = 1;
a = [1 2 3 4 5 5 1 3 6 5 3 2 2 6 7 8 9 6 5 4 2 5 8 4 9 7 4];
y = sin(a);
plot(a, y);
axis([0 20 0 10])