function varargout = serial_communication2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @serial_communication2_OpeningFcn, ...
                   'gui_OutputFcn',  @serial_communication2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function serial_communication2_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
warning('off');
javaFrame = get(hObject, 'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.jpg'));
%% 初始化参数
hasData = false; %表征串口是否接收到数据
isShow = false;  %表征是否正在进行数据显示，即是否正在执行函数dataDisp
isStopDisp = false;  %表征是否按下了【停止显示】按钮
numRec = 0;    %接收字符计数
strRec = '';   %已接收的字符串
%% 将上述参数作为应用数据，存入窗口对象内
setappdata(hObject, 'hasData', hasData);
setappdata(hObject, 'strRec', strRec);
setappdata(hObject, 'numRec', numRec);
setappdata(hObject, 'isShow', isShow);
setappdata(hObject, 'isStopDisp', isStopDisp);
guidata(hObject, handles);

function varargout = serial_communication2_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function com_Callback(~, ~, ~)

function com_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rate_Callback(~, ~, ~)

function rate_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function jiaoyan_Callback(~, ~, ~)

function jiaoyan_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function data_bits_Callback(~, ~, ~)

function data_bits_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stop_bits_Callback(~, ~, ~)

function stop_bits_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function start_serial_Callback(hObject, ~, handles)
%   【打开/关闭串口】按钮的回调函数
%    打开串口，并初始化相关参数

%% 若按下【打开串口】按钮，打开串口
if get(hObject, 'value')
    %% 获取串口的端口名
    com_n = sprintf('com%d', get(handles.com, 'value'));
    %% 获取波特率
    rates = [300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
    baud_rate = rates(get(handles.rate, 'value'));
    %% 获取校验位设置
    switch get(handles.jiaoyan, 'value')
        case 1
            jiaoyan = 'none';
        case 2
            jiaoyan = 'odd';
        case 3
            jiaoyan = 'even';
    end
    %% 获取数据位个数
    data_bits = 5 + get(handles.data_bits, 'value');
    %% 获取停止位个数
    stop_bits = get(handles.stop_bits, 'value');
    %% 创建串口对象
    scom = serial(com_n);
    %% 配置串口属性，指定其回调函数
    set(scom, 'BaudRate', baud_rate, 'Parity', jiaoyan, 'DataBits',...
        data_bits, 'StopBits', stop_bits, 'BytesAvailableFcnCount', 10,...
        'BytesAvailableFcnMode', 'byte', 'BytesAvailableFcn', {@bytes, handles},...
        'TimerPeriod', 0.05, 'timerfcn', {@dataDisp, handles});
    %% 将串口对象的句柄作为用户数据，存入窗口对象
    set(handles.figure1, 'UserData', scom);
    %% 尝试打开串口
    try
        fopen(scom);  %打开串口
    catch   % 若串口打开失败，提示“串口不可获得！”
        msgbox('串口不可获得！');
        set(hObject, 'value', 0);  %弹起本按钮 
        return;
    end
    %% 打开串口后，允许串口发送数据，清空接收显示区，点亮串口状态指示灯，
    %% 并更改本按钮文本为“关闭串口”
    set(handles.xianshi, 'string', ''); %清空接收显示区
    set(hObject, 'String', '关闭串口');  %设置本按钮文本为“关闭串口”
else  %若关闭串口
    %% 停止并删除定时器
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    %% 停止并删除串口对象
    scoms = instrfind;
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end

function dataDisp(obj, event, handles)
global value
global AT AH AS;
global BT BH BS;
global CT CH CS;
global single_string_size;
global which_mode;
if isempty(AT)
    AT = [];
    AH = [];
    AS = [];
    BT = [];
    BH = [];
    BS = [];
    CT = [];
    CH = [];
    CS = [];
    single_string_size=21;
    which_mode='A';
end
%	串口的TimerFcn回调函数
%   串口数据显示
%% 获取参数
hasData = getappdata(handles.figure1, 'hasData'); %串口是否收到数据
strRec = getappdata(handles.figure1, 'strRec');   %串口数据的字符串形式，定时显示该数据
numRec = getappdata(handles.figure1, 'numRec');   %串口接收到的数据个数
%% 若串口没有接收到数据，先尝试接收串口数据
if ~hasData
    bytes(obj, event, handles);
end
%% 若串口有数据，显示串口数据
if hasData
    setappdata(handles.figure1, 'isHexDisp', false);
    %% 在执行显示数据模块时，不接受串口数据，即不执行BytesAvailableFcn回调函数
    setappdata(handles.figure1, 'isShow', true); 
    %% 若要显示的字符串长度超过10000，清空显示区
    if length(strRec) > 10000
        strRec = '';
        setappdata(handles.figure1, 'strRec', strRec);
    end
    %% 显示数据
    if strRec(1)=='0'
        strRec(1)=[];
    end
    set(handles.xianshi, 'string', strRec);
    disp(strRec);
    %% 保存一波    
    value=get(handles.xianshi,'string');
    save('ysw.mat','value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %% 读取数据选择模式
    data_load_show = value;
%     disp(data_load_show)
    [r, c] = size(data_load_show);
    if c>single_string_size+1
        switch data_load_show(r,c-single_string_size+1)
            case 'A'
                which_mode='A';
            case 'B'
                which_mode='B';
            case 'C'
                which_mode='C';
        end
        %%处理数据
        for i = c-single_string_size+1:1:c
        % 采集到的A的数据
            if which_mode=='A'
                if data_load_show(r,i)=='T'
                    AT = [AT str2double(data_load_show(r,i+2:i+5))]
                end
                if data_load_show(r,i)=='H'
                    AH = [AH str2double(data_load_show(r,i+2:i+3))]
                end
                if data_load_show(r,i)=='S'
                    AS = [AS str2double(data_load_show(r,i+2:i+4))]
                end
            end
        % 采集到的B的数据
            if which_mode=='B'
                if data_load_show(r,i)=='T'
                    BT = [BT str2double(data_load_show(r,i+2:i+5))]
                end
                if data_load_show(r,i)=='H'
                    BH = [BH str2double(data_load_show(r,i+2:i+3))]
                end
                if data_load_show(r,i)=='S'
                    BS = [BS str2double(data_load_show(r,i+2:i+4))]
                end
            end
        % 采集到的C的数据
            if which_mode=='C'
                if data_load_show(r,i)=='T'
                    CT = [CT str2double(data_load_show(r,i+2:i+5))]
                end
                if data_load_show(r,i)=='H'
                    CH = [CH str2double(data_load_show(r,i+2:i+3))]
                end
                if data_load_show(r,i)=='S'
                    CS = [CS str2double(data_load_show(r,i+2:i+4))]
                end
            end
        end
    end
%% 绘制图像
delete(allchild(handles.plotAD))
delete(allchild(handles.axes15))
delete(allchild(handles.axes16))
if size(AT,2)>2&& size(AH,2)>2&& size(AS,2)>2&& size(BT,2)>2&& size(BH,2)>2&& size(BS,2)>2&&...
         size(CT,2)>2&& size(CH,2)>2&& size(CS,2)>2
     % 湿度
    AH_x = 1:1:size(AH,2);
    BH_x = 1:1:size(BH,2);
    CH_x = 1:1:size(CH,2);
    plot(handles.axes15,AH_x,AH,'R',BH_x,BH,'G',CH_x,CH,'B');
    set(handles.axes15,'XLim',[1 size(AH,2)*2],'YLim',[0 80]);
    % 温度
    AT_x = 1:1:size(AT,2);
    BT_x = 1:1:size(BT,2);
    CT_x = 1:1:size(CT,2);
    plot(handles.plotAD,AT_x,AT,'R',BT_x,BT,'G',CT_x,CT,'B');
    set(handles.plotAD,'XLim',[1 size(AT,2)*2],'YLim',[0 100]);

    % 烟雾
    AS_x = 1:1:size(AS,2);
    BS_x = 1:1:size(BS,2);
    CS_x = 1:1:size(CS,2);
    plot(handles.axes16,AS_x,AS,'R',BS_x,BS,'G',CS_x,CS,'B');
    set(handles.axes16,'XLim',[1 size(AS,2)*2],'YLim',[0 1000]);
    
    % 计算预警数据
    meanT = (mean(AT(size(AT,2)-1:size(AT,2)))+mean(BT(size(BT,2)-1:size(BT,...
        2)))+mean(CT(size(CT,2)-1:size(CT,2))))/3;
    meanH = (mean(AH(size(AH,2)-1:size(AH,2)))+mean(BH(size(BH,2)-1:size(BH,...
        2))))/2;
    meanS = (mean(AS(size(AS,2)-1:size(AS,2)))+mean(BS(size(BS,2)-1:size(BS,...
        2)))+mean(CS(size(CS,2)-1:size(CS,2))))/3;
    set(handles.T,'string', roundn(meanT,-2));
    set(handles.H,'string', roundn(meanH,-2));
    set(handles.S,'string', roundn(meanS,-2));
    
    %% 报警
    if meanT>0&&meanT<30
        set(handles.stateT,'string', '正常');
    elseif meanT>30&&meanT<40
        set(handles.stateT,'string', '预警');
    elseif meanT>40
        set(handles.stateT,'string', '报警');
    else
        set(handles.stateT,'string', '错误');
    end
    %
    if meanH>0&&meanH<60
        set(handles.stateH,'string', '正常');
    elseif meanH>60&&meanH<75
        set(handles.stateH,'string', '预警');
    elseif meanH>75
        set(handles.stateH,'string', '报警');
    else
        set(handles.stateH,'string', '错误');
    end
    %
    if meanS>0&&meanS==0&&meanS<100
        set(handles.stateS,'string', '正常');
    elseif meanS>100
        set(handles.stateS,'string', '报警');
    else
        set(handles.stateS,'string', '错误');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     [count_r_A, count_c_A] = size(AT);
%     [count_r_B, count_c_B] = size(BT);
%     [count_r_C, count_c_C] = size(CT);
%     if count_c_A>2        
%         set(handles.T,'string', AT(count_r_A, count_c_A));
%         set(handles.H,'string', HT(count_r_B, count_c));
%         set(handles.S,'string', ST(count_r, count_c));
%     end
    %% 更新接收计数
    set(handles.rec,'string', numRec);
    %% 更新hasData标志，表明串口数据已经显示
    setappdata(handles.figure1, 'hasData', false);
    %% 给数据显示模块解锁
    setappdata(handles.figure1, 'isShow', false);
end
 
function bytes(obj, ~, handles)
%   串口的BytesAvailableFcn回调函数
%   串口接收数据
%% 获取参数
strRec = getappdata(handles.figure1, 'strRec'); %获取串口要显示的数据
numRec = getappdata(handles.figure1, 'numRec'); %获取串口已接收数据的个数
isStopDisp = getappdata(handles.figure1, 'isStopDisp'); %是否按下了【停止显示】按钮
isHexDisp = getappdata(handles.figure1, 'isHexDisp'); %是否十六进制显示
isShow = getappdata(handles.figure1, 'isShow');  %是否正在执行显示数据操作
%% 若正在执行数据显示操作，暂不接收串口数据
if isShow
    return;
end
%% 获取串口可获取的数据个数
n = get(obj, 'BytesAvailable');
%% 若串口有数据，接收所有数据
if n
    %% 更新hasData参数，表明串口有数据需要显示
    setappdata(handles.figure1, 'hasData', true);
    %% 读取串口数据
    a = fread(obj, n, 'uchar');
    %% 若没有停止显示，将接收到的数据解算出来，准备显示
    if ~isStopDisp 
        %% 根据进制显示的状态，解析数据为要显示的字符串
        if ~isHexDisp 
            c = char(a');
        else
            strHex = dec2hex(a')';
            strHex2 = [strHex; blanks(size(a, 1))];
            c = strHex2(:)';
        end
        %% 更新已接收的数据个数
        numRec = numRec + size(a, 1);
        %% 更新要显示的字符串
        strRec = [strRec c];
    end
    %% 更新参数
    setappdata(handles.figure1, 'numRec', numRec); %更新已接收的数据个数
    setappdata(handles.figure1, 'strRec', strRec); %更新要显示的字符串
end


function qingkong_Callback(hObject, eventdata, handles)
%% 清空要显示的字符串
setappdata(handles.figure1, 'strRec', '');
%% 清空显示
set(handles.xianshi, 'String', '');

function stop_disp_Callback(hObject, ~, handles)
%% 根据【停止显示】按钮的状态，更新isStopDisp参数
if get(hObject, 'Value')
    isStopDisp = true;
else
    isStopDisp = false;
end
setappdata(handles.figure1, 'isStopDisp', isStopDisp);

function radiobutton1_Callback(hObject, eventdata, ~)

function radiobutton2_Callback(hObject, ~, handles)

function togglebutton4_Callback(~, eventdata, handles)

function hex_disp_Callback(hObject, eventdata, handles)
%% 根据【十六进制显示】复选框的状态，更新isHexDisp参数
if get(hObject, 'Value')
    isHexDisp = true;
else
    isHexDisp = false;
end
setappdata(handles.figure1, 'isHexDisp', isHexDisp);


function checkbox2_Callback(hObject, eventdata, ~)



function period1_Callback(hObject, eventdata, handles)

function period1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clear_count_Callback(~, eventdata, handles)
%% 计数清零，并更新参数numRec和numSend
set([handles.rec, handles.trans], 'string', '0')
setappdata(handles.figure1, 'numRec', 0);
setappdata(handles.figure1, 'numSend', 0);

function copy_data_Callback(hObject, eventdata, handles)
%% 设置是否允许复制接收数据显示区内的数据
if get(hObject,'value')
    set(handles.xianshi, 'enable', 'on');
else
    set(handles.xianshi, 'enable', 'inactive');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
%   关闭窗口时，检查定时器和串口是否已关闭
%   若没有关闭，则先关闭
%% 查找定时器
t = timerfind;
%% 若存在定时器对象，停止并关闭
if ~isempty(t)
    stop(t);  %若定时器没有停止，则停止定时器
    delete(t);
end
%% 查找串口对象
scoms = instrfind;
%% 尝试停止、关闭删除串口对象
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end
%% 关闭窗口
delete(hObject);

% --- Executes on button press in save_data.
function save_data_Callback(hObject, ~, handles)
data_load_show = importdata('ysw.mat')
data_load_show = mat2str(data_load_show);

% 数据保存到文件
% strRec = getappdata(handles.figure1, 'strRec');   %串口数据的字符串形式，定时显示该数据
fid = fopen('data.txt','wt');
fprintf(fid,'%s', data_load_show);
fclose(fid);
% save('ADdata.txt','val');
% 保存成功提示弹窗
close(figure(1))
m=msgbox('数据已保存！','提示');
pause(1);delete(m);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function xianshi_CreateFcn(hObject, ~, ~)
% hObject    handle to xianshi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over xianshi.
function xianshi_ButtonDownFcn(~, ~, ~)
% hObject    handle to xianshi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on xianshi and none of its controls.
function xianshi_KeyPressFcn(~, ~, ~)
% hObject    handle to xianshi (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider3_Callback(~, ~, ~)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, ~, ~)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AT AH AS;
global BT BH BS;
global CT CH CS;
AT = [];
AH = [];
AS = [];
BT = [];
BH = [];
BS = [];
CT = [];
CH = [];
CS = [];


% --- Executes during object creation, after setting all properties.


% --- Executes on mouse press over axes background.
function plotAD_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to plotAD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function plotAD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotAD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plotAD


% --- Executes during object creation, after setting all properties.
function rec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function rec_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over rec.
function rec_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
