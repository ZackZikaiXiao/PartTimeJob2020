function length = linelength( f, a, b )
%linelength ���߳��ȼ���
%   f:����
%   a:x1
%   b:x2
f = sqrt(1+diff(f, symvar(f,1))^2);
length = double(int(f,a,b));
end

