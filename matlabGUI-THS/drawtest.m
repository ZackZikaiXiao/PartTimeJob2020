function varargout = drawtest(varargin)
% DRAWTEST MATLAB code for drawtest.fig
%      DRAWTEST, by itself, creates a new DRAWTEST or raises the existing
%      singleton*.
%
%      H = DRAWTEST returns the handle to a new DRAWTEST or the handle to
%      the existing singleton*.
%
%      DRAWTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWTEST.M with the given input arguments.
%
%      DRAWTEST('Property','Value',...) creates a new DRAWTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drawtest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drawtest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawtest

% Last Modified by GUIDE v2.5 22-May-2020 21:44:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drawtest_OpeningFcn, ...
                   'gui_OutputFcn',  @drawtest_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before drawtest is made visible.
function drawtest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawtest (see VARARGIN)

% Choose default command line output for drawtest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drawtest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drawtest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
delete(allchild(handles.axes1))
global count;
if isempty(count)
    count=2;
end
handles.x=-pi:0.5:pi;
x = handles.x;
y = sin(x).*count;
disp(count)
hold on;
plot(handles.axes1,x,y,'b')
plot(handles.axes1,x,y*2,'r')
count = count + 1;




% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
