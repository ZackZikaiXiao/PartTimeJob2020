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
%% ��ʼ������
hasData = false; %���������Ƿ���յ�����
isShow = false;  %�����Ƿ����ڽ���������ʾ�����Ƿ�����ִ�к���dataDisp
isStopDisp = false;  %�����Ƿ����ˡ�ֹͣ��ʾ����ť
numRec = 0;    %�����ַ�����
strRec = '';   %�ѽ��յ��ַ���
%% ������������ΪӦ�����ݣ����봰�ڶ�����
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
%   ����/�رմ��ڡ���ť�Ļص�����
%    �򿪴��ڣ�����ʼ����ز���

%% �����¡��򿪴��ڡ���ť���򿪴���
if get(hObject, 'value')
    %% ��ȡ���ڵĶ˿���
    com_n = sprintf('com%d', get(handles.com, 'value'));
    %% ��ȡ������
    rates = [300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
    baud_rate = rates(get(handles.rate, 'value'));
    %% ��ȡУ��λ����
    switch get(handles.jiaoyan, 'value')
        case 1
            jiaoyan = 'none';
        case 2
            jiaoyan = 'odd';
        case 3
            jiaoyan = 'even';
    end
    %% ��ȡ����λ����
    data_bits = 5 + get(handles.data_bits, 'value');
    %% ��ȡֹͣλ����
    stop_bits = get(handles.stop_bits, 'value');
    %% �������ڶ���
    scom = serial(com_n);
    %% ���ô������ԣ�ָ����ص�����
    set(scom, 'BaudRate', baud_rate, 'Parity', jiaoyan, 'DataBits',...
        data_bits, 'StopBits', stop_bits, 'BytesAvailableFcnCount', 10,...
        'BytesAvailableFcnMode', 'byte', 'BytesAvailableFcn', {@bytes, handles},...
        'TimerPeriod', 0.05, 'timerfcn', {@dataDisp, handles});
    %% �����ڶ���ľ����Ϊ�û����ݣ����봰�ڶ���
    set(handles.figure1, 'UserData', scom);
    %% ���Դ򿪴���
    try
        fopen(scom);  %�򿪴���
    catch   % �����ڴ�ʧ�ܣ���ʾ�����ڲ��ɻ�ã���
        msgbox('���ڲ��ɻ�ã�');
        set(hObject, 'value', 0);  %���𱾰�ť 
        return;
    end
    %% �򿪴��ں������ڷ������ݣ���ս�����ʾ������������״ָ̬ʾ�ƣ�
    %% �����ı���ť�ı�Ϊ���رմ��ڡ�
    set(handles.xianshi, 'string', ''); %��ս�����ʾ��
    set(hObject, 'String', '�رմ���');  %���ñ���ť�ı�Ϊ���رմ��ڡ�
else  %���رմ���
    %% ֹͣ��ɾ����ʱ��
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    %% ֹͣ��ɾ�����ڶ���
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
%	���ڵ�TimerFcn�ص�����
%   ����������ʾ
%% ��ȡ����
hasData = getappdata(handles.figure1, 'hasData'); %�����Ƿ��յ�����
strRec = getappdata(handles.figure1, 'strRec');   %�������ݵ��ַ�����ʽ����ʱ��ʾ������
numRec = getappdata(handles.figure1, 'numRec');   %���ڽ��յ������ݸ���
%% ������û�н��յ����ݣ��ȳ��Խ��մ�������
if ~hasData
    bytes(obj, event, handles);
end
%% �����������ݣ���ʾ��������
if hasData
    setappdata(handles.figure1, 'isHexDisp', false);
    %% ��ִ����ʾ����ģ��ʱ�������ܴ������ݣ�����ִ��BytesAvailableFcn�ص�����
    setappdata(handles.figure1, 'isShow', true); 
    %% ��Ҫ��ʾ���ַ������ȳ���10000�������ʾ��
    if length(strRec) > 10000
        strRec = '';
        setappdata(handles.figure1, 'strRec', strRec);
    end
    %% ��ʾ����
    if strRec(1)=='0'
        strRec(1)=[];
    end
    set(handles.xianshi, 'string', strRec);
    disp(strRec);
    %% ����һ��    
    value=get(handles.xianshi,'string');
    save('ysw.mat','value');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %% ��ȡ����ѡ��ģʽ
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
        %%��������
        for i = c-single_string_size+1:1:c
        % �ɼ�����A������
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
        % �ɼ�����B������
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
        % �ɼ�����C������
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
%% ����ͼ��
delete(allchild(handles.plotAD))
delete(allchild(handles.axes15))
delete(allchild(handles.axes16))
if size(AT,2)>2&& size(AH,2)>2&& size(AS,2)>2&& size(BT,2)>2&& size(BH,2)>2&& size(BS,2)>2&&...
         size(CT,2)>2&& size(CH,2)>2&& size(CS,2)>2
     % ʪ��
    AH_x = 1:1:size(AH,2);
    BH_x = 1:1:size(BH,2);
    CH_x = 1:1:size(CH,2);
    plot(handles.axes15,AH_x,AH,'R',BH_x,BH,'G',CH_x,CH,'B');
    set(handles.axes15,'XLim',[1 size(AH,2)*2],'YLim',[0 80]);
    % �¶�
    AT_x = 1:1:size(AT,2);
    BT_x = 1:1:size(BT,2);
    CT_x = 1:1:size(CT,2);
    plot(handles.plotAD,AT_x,AT,'R',BT_x,BT,'G',CT_x,CT,'B');
    set(handles.plotAD,'XLim',[1 size(AT,2)*2],'YLim',[0 100]);

    % ����
    AS_x = 1:1:size(AS,2);
    BS_x = 1:1:size(BS,2);
    CS_x = 1:1:size(CS,2);
    plot(handles.axes16,AS_x,AS,'R',BS_x,BS,'G',CS_x,CS,'B');
    set(handles.axes16,'XLim',[1 size(AS,2)*2],'YLim',[0 1000]);
    
    % ����Ԥ������
    meanT = (mean(AT(size(AT,2)-1:size(AT,2)))+mean(BT(size(BT,2)-1:size(BT,...
        2)))+mean(CT(size(CT,2)-1:size(CT,2))))/3;
    meanH = (mean(AH(size(AH,2)-1:size(AH,2)))+mean(BH(size(BH,2)-1:size(BH,...
        2))))/2;
    meanS = (mean(AS(size(AS,2)-1:size(AS,2)))+mean(BS(size(BS,2)-1:size(BS,...
        2)))+mean(CS(size(CS,2)-1:size(CS,2))))/3;
    set(handles.T,'string', roundn(meanT,-2));
    set(handles.H,'string', roundn(meanH,-2));
    set(handles.S,'string', roundn(meanS,-2));
    
    %% ����
    if meanT>0&&meanT<30
        set(handles.stateT,'string', '����');
    elseif meanT>30&&meanT<40
        set(handles.stateT,'string', 'Ԥ��');
    elseif meanT>40
        set(handles.stateT,'string', '����');
    else
        set(handles.stateT,'string', '����');
    end
    %
    if meanH>0&&meanH<60
        set(handles.stateH,'string', '����');
    elseif meanH>60&&meanH<75
        set(handles.stateH,'string', 'Ԥ��');
    elseif meanH>75
        set(handles.stateH,'string', '����');
    else
        set(handles.stateH,'string', '����');
    end
    %
    if meanS>0&&meanS==0&&meanS<100
        set(handles.stateS,'string', '����');
    elseif meanS>100
        set(handles.stateS,'string', '����');
    else
        set(handles.stateS,'string', '����');
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
    %% ���½��ռ���
    set(handles.rec,'string', numRec);
    %% ����hasData��־���������������Ѿ���ʾ
    setappdata(handles.figure1, 'hasData', false);
    %% ��������ʾģ�����
    setappdata(handles.figure1, 'isShow', false);
end
 
function bytes(obj, ~, handles)
%   ���ڵ�BytesAvailableFcn�ص�����
%   ���ڽ�������
%% ��ȡ����
strRec = getappdata(handles.figure1, 'strRec'); %��ȡ����Ҫ��ʾ������
numRec = getappdata(handles.figure1, 'numRec'); %��ȡ�����ѽ������ݵĸ���
isStopDisp = getappdata(handles.figure1, 'isStopDisp'); %�Ƿ����ˡ�ֹͣ��ʾ����ť
isHexDisp = getappdata(handles.figure1, 'isHexDisp'); %�Ƿ�ʮ��������ʾ
isShow = getappdata(handles.figure1, 'isShow');  %�Ƿ�����ִ����ʾ���ݲ���
%% ������ִ��������ʾ�������ݲ����մ�������
if isShow
    return;
end
%% ��ȡ���ڿɻ�ȡ�����ݸ���
n = get(obj, 'BytesAvailable');
%% �����������ݣ�������������
if n
    %% ����hasData����������������������Ҫ��ʾ
    setappdata(handles.figure1, 'hasData', true);
    %% ��ȡ��������
    a = fread(obj, n, 'uchar');
    %% ��û��ֹͣ��ʾ�������յ������ݽ��������׼����ʾ
    if ~isStopDisp 
        %% ���ݽ�����ʾ��״̬����������ΪҪ��ʾ���ַ���
        if ~isHexDisp 
            c = char(a');
        else
            strHex = dec2hex(a')';
            strHex2 = [strHex; blanks(size(a, 1))];
            c = strHex2(:)';
        end
        %% �����ѽ��յ����ݸ���
        numRec = numRec + size(a, 1);
        %% ����Ҫ��ʾ���ַ���
        strRec = [strRec c];
    end
    %% ���²���
    setappdata(handles.figure1, 'numRec', numRec); %�����ѽ��յ����ݸ���
    setappdata(handles.figure1, 'strRec', strRec); %����Ҫ��ʾ���ַ���
end


function qingkong_Callback(hObject, eventdata, handles)
%% ���Ҫ��ʾ���ַ���
setappdata(handles.figure1, 'strRec', '');
%% �����ʾ
set(handles.xianshi, 'String', '');

function stop_disp_Callback(hObject, ~, handles)
%% ���ݡ�ֹͣ��ʾ����ť��״̬������isStopDisp����
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
%% ���ݡ�ʮ��������ʾ����ѡ���״̬������isHexDisp����
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
%% �������㣬�����²���numRec��numSend
set([handles.rec, handles.trans], 'string', '0')
setappdata(handles.figure1, 'numRec', 0);
setappdata(handles.figure1, 'numSend', 0);

function copy_data_Callback(hObject, eventdata, handles)
%% �����Ƿ������ƽ���������ʾ���ڵ�����
if get(hObject,'value')
    set(handles.xianshi, 'enable', 'on');
else
    set(handles.xianshi, 'enable', 'inactive');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
%   �رմ���ʱ����鶨ʱ���ʹ����Ƿ��ѹر�
%   ��û�йرգ����ȹر�
%% ���Ҷ�ʱ��
t = timerfind;
%% �����ڶ�ʱ������ֹͣ���ر�
if ~isempty(t)
    stop(t);  %����ʱ��û��ֹͣ����ֹͣ��ʱ��
    delete(t);
end
%% ���Ҵ��ڶ���
scoms = instrfind;
%% ����ֹͣ���ر�ɾ�����ڶ���
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end
%% �رմ���
delete(hObject);

% --- Executes on button press in save_data.
function save_data_Callback(hObject, ~, handles)
data_load_show = importdata('ysw.mat')
data_load_show = mat2str(data_load_show);

% ���ݱ��浽�ļ�
% strRec = getappdata(handles.figure1, 'strRec');   %�������ݵ��ַ�����ʽ����ʱ��ʾ������
fid = fopen('data.txt','wt');
fprintf(fid,'%s', data_load_show);
fclose(fid);
% save('ADdata.txt','val');
% ����ɹ���ʾ����
close(figure(1))
m=msgbox('�����ѱ��棡','��ʾ');
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
