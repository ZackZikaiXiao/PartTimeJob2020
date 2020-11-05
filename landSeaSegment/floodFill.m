function colored_Image = floodFill( image, target_Loc_x, target_Loc_y, oldcolor, newcolor)
colored_Image = image;

quene = zeros(10000, 2); %队列
quene(1,:) = [target_Loc_x target_Loc_y];
iter = 1;   % 指向quene最后一个有效元素
while(quene(1, 1)~=0)      % 栈不为空
    lastElement = quene(iter, :);
    target_Loc_x = lastElement(1);
    target_Loc_y = lastElement(2);   
    quene_deliver = 0;  % 判断是否满足条件而出栈，是则为1，否为0
    if (target_Loc_x >= 1) && (target_Loc_x <= size(colored_Image,1)) && (target_Loc_y >= 1) && (target_Loc_y <= size(colored_Image,2))...
            &&(colored_Image(target_Loc_x,target_Loc_y) == oldcolor) %满足范围条件与颜色条件
        colored_Image(target_Loc_x,target_Loc_y) = newcolor;   % 颜色替换
        quene(iter,:) = [0 0];
        iter = iter - 1;
        quene_deliver = 1;

        if target_Loc_x-1 >=1 
            if colored_Image(target_Loc_x-1, target_Loc_y) == oldcolor
                quene(iter+1,:) = [target_Loc_x-1 target_Loc_y];
                iter = iter + 1;
            end
        end
        if target_Loc_x+1 <= size(colored_Image,1) 
            if colored_Image(target_Loc_x+1, target_Loc_y) == oldcolor
                quene(iter+1,:) = [target_Loc_x+1 target_Loc_y];
                iter = iter + 1;
            end
        end
         if target_Loc_y-1 >= 1 
             if colored_Image(target_Loc_x, target_Loc_y-1) == oldcolor
                quene(iter+1,:) = [target_Loc_x target_Loc_y-1];
                iter = iter + 1;
             end 
         end
        
        if target_Loc_y+1 <= size(colored_Image,2) 
            if colored_Image(target_Loc_x, target_Loc_y+1) == oldcolor
                quene(iter+1,:) = [target_Loc_x target_Loc_y+1];
                iter = iter + 1;
            end
        end
    end
%     disp(quene)    
%     disp(img_bw(1:20, 1:20))
    if ~quene_deliver
        quene(iter, :) = [0 0];
        iter = iter - 1;
    end 
end  

