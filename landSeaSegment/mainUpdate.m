clc;
clear;

imgScr = imread('raw.jpg');
T = graythresh(imgScr);
img_bw = im2bw(imgScr,T);
img_bw = im2uint8(img_bw);
[r, c] = size(img_bw)
% img_bw = img_bw(1:50, 1:50)

% ½�غ��������Զ�ѡ��
size = 20;
seedlist_r = randperm(min(r,c));
seedlist_c = randperm(min(r,c));
seedlist = rot90([seedlist_r;seedlist_c]);
seedLand = [0 0];
seedSea = [0 0];
iter = 1;
while((isequal(seedLand,[0 0]) || isequal(seedSea,[0 0])) && iter<=r) 
    if seedlist(iter,1)-size>1 && seedlist(iter,1)+size<r...
            && seedlist(iter,2)-size>1 && seedlist(iter,2)+size<c
        if isequal(img_bw(seedlist(iter,1)-size:seedlist(iter,1)+size,seedlist(iter,2)-size:seedlist(iter,2)+size),...
                zeros(2*size+1,2*size+1))
            seedSea = seedlist(iter,:);
        end
        if isequal(img_bw(seedlist(iter,1)-size:seedlist(iter,1)+size,seedlist(iter,2)-size:seedlist(iter,2)+size),...
                ones(2*size+1,2*size+1)*255)
            seedLand = seedlist(iter,:);
        end
    end
    iter = iter + 1;
end
clear size seedlist_r seedlist_c seedlist iter




% ½�ط�����䣬����Ѱ��ͬ��������Ĺ�������
img_bw = floodFill(img_bw, seedLand(1), seedLand(2), 255, 254);
% ���󷺺����
img_bw = floodFill(img_bw, seedSea(1), seedSea(2),0, 1)


% ����������
for i = 1:r
    for j = 1:c
        if img_bw(i,j) ~= 254 && img_bw(i,j) ~= 1 &&  img_bw(i,j) ~= 100    % ��������
            img_bw = floodFill(img_bw, i, j, img_bw(i,j), 100);
        end
    end
end

clear i j line_temp

% �����������
for i = 1:r
    for j = 1:c
        if img_bw(i, j) == 100     % ��ĳһ��Ϊ��������ʱ
            point_flag = 0;     % �Ƿ�����������Ϊ1
            % ��
            if i-1 > 1 && point_flag == 0         % ��ֹԽ��
                if  img_bw(i, j) ~=  img_bw(i-1, j)
                    img_bw = floodFill(img_bw, i, j, img_bw(i, j), img_bw(i-1, j));
                end
                point_flag = 1;
            end
            % ��
            if i+1 <= size(img_bw, 1) && point_flag == 0         % ��ֹԽ��
                if  img_bw(i+1, j) ~=  img_bw(i, j)
                    img_bw = floodFill(img_bw, i, j,  img_bw(i, j),  img_bw(i+1, j));
                end
                point_flag = 1;
            end
            % ��
            if j-1 >= 0 && point_flag == 0        
                if  img_bw(i, j-1) ~=  img_bw(i, j)
                    img_bw = floodFill(img_bw, i, j,  img_bw(i, j),  img_bw(i, j-1));
                end
                point_flag = 1;
            end
            % ��
            if j+1 <= size(img_bw, 2) && point_flag == 0     
                if  img_bw(i, j) ~=  img_bw(i, j+1)
                    img_bw = floodFill(img_bw, i, j,  img_bw(i, j), line_temp(j+1));
                end
                point_flag = 1;
            end         
        end
    end
end

% ���ͼ������
[r, c] = size(img_bw)
for i = 1:r
    for j = 1:c
        if img_bw(i, j) == 254  
            img_bw(i, j) = 255;
        elseif img_bw(i, j) == 1
            line_temp(j) = 0;
        end
    end
end

imshow(img_bw);