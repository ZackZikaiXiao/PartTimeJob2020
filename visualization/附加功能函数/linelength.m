function length = linelength( f, a, b )
%linelength 曲线长度计算
%   f:函数
%   a:x1
%   b:x2
f = sqrt(1+diff(f, symvar(f,1))^2);
length = double(int(f,a,b));
end

