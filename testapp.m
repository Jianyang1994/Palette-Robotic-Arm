function varargout = testapp(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testapp_OpeningFcn, ...
                   'gui_OutputFcn',  @testapp_OutputFcn, ...
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


function testapp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testapp (see VARARGIN)

% Choose default command line output for testapp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testapp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testapp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global x;
x=serial('COM7','BAUD',9600);
disp("Sending Communication Requist");
fopen(x);
disp("Connected")


% --- Executes on button press in StartRunning.
function StartRunning_Callback(hObject, eventdata, handles)
% hObject    handle to StartRunning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
X=27.5; %cm
Y=50;%cm
Z=17;%cm
h=10;%cm
dx=3.3; % the unit is cm
dy=3.6;%the unit is cm
L1=32; %the unit is cm
L2=35;
m=11;
n=8;
dt=1;
joint0=zeros(n,m);
joint1=zeros(n,m);
joint2=zeros(n,m);
joint3=zeros(n,m);
joint1_1=zeros(n,m);
joint2_1=zeros(n,m);
joint3_1=zeros(n,m);
disp("Start calculating data");
for i=1:m
for j=1:n
joint0(i,j)=rad2deg(atan((Y-(i-1)*dy)/(X-(j-1)*dx)));
L3=sqrt((Y-(i-1)*dy)^2+(X-(j-1)*dx)^2+Z^2);
joint1(i,j)=rad2deg(acos((L1^2+L3^2-L2^2)/(2*L1*L3)));
joint2(i,j)=rad2deg(acos((L1^2+L2^2-L3^2)/(2*L1*L2)));
joint3(i,j)=rad2deg(acos((L2^2+L3^2-L1^2)/(2*L2*L3)))+rad2deg(atan((Z)/(sqrt(X^2+Y^2))))+90;
joint1(i,j)=-1*(joint1(i,j)-64);
joint2(i,j)=(joint2(i,j)-64);
joint3(i,j)=joint3(i,j)-180;
L3_1=sqrt((Y-(i-1)*dy)^2+(X-(j-1)*dx)^2+(Z-h)^2);
joint1_1(i,j)=rad2deg(acos((L1^2+L3_1^2-L2^2)/(2*L1*L3_1)));
joint2_1(i,j)=rad2deg(acos((L1^2+L2^2-L3_1^2)/(2*L1*L2)));
joint3_1(i,j)=rad2deg(acos((L2^2+L3^2-L1^2)/(2*L2*L3)))+rad2deg(atan((Z)/(sqrt(X^2+Y^2))))+90;
joint1_1(i,j)=-1*(joint1_1(i,j)-64);
joint2_1(i,j)=(joint2_1(i,j)-64);
joint3_1(i,j)=joint3_1(i,j)-180;
end
end
disp("Finish calculation");
disp("wait 3 second to send joint angle");
for i=1:m
for j=1:n
sw=0;   
MP=strcat(num2str(joint0(i,j)),',',num2str(joint1(i,j)),',',num2str(joint2(i,j)),',',num2str(joint3(i,j)),',',num2str(dt),',',num2str(sw));
TP=strcat(num2str(joint0(i,j)),',',num2str(joint1_1(i,j)),',',num2str(joint2_1(i,j)),',',num2str(joint3_1(i,j)),',',num2str(dt),',',num2str(sw));

fprintf(x,TP);
pause(2);
fprintf(x,MP);
pause(2);
fprintf(x,TP);
pause(2);
end
end


% --- Executes on button press in Stoprunning.
function Stoprunning_Callback(hObject, eventdata, handles)
% hObject    handle to Stoprunning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
fclose(x);
disp("the serial has been closed");


% --- Executes on button press in connectionrequist.
function connectionrequist_Callback(hObject, eventdata, handles)
% hObject    handle to connectionrequist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp("connection success");
global x;
TEST=strcat(num2str(0),',',num2str(0),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);


% --- Executes on button press in deg10.
function deg10_Callback(hObject, eventdata, handles)
% hObject    handle to deg10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(10),',',num2str(0),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);

% --- Executes on button press in deg50.
function deg50_Callback(hObject, eventdata, handles)
% hObject    handle to deg50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(50),',',num2str(0),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);

% --- Executes on button press in deg90.
function deg90_Callback(hObject, eventdata, handles)
% hObject    handle to deg90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(90),',',num2str(0),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);


% --- Executes on button press in M110.
function M110_Callback(hObject, eventdata, handles)
% hObject    handle to M110 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(0),',',num2str(10),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);

% --- Executes on button press in M250.
function M250_Callback(hObject, eventdata, handles)
% hObject    handle to M250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x;
TEST=strcat(num2str(0),',',num2str(50),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);
% --- Executes on button press in M290.
function M290_Callback(hObject, eventdata, handles)
% hObject    handle to M290 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(0),',',num2str(90),',',num2str(0),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);

% --- Executes on button press in M310.
function M310_Callback(hObject, eventdata, handles)
% hObject    handle to M310 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(0),',',num2str(0),',',num2str(10),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);

% --- Executes on button press in M350.
function M350_Callback(hObject, eventdata, handles)
% hObject    handle to M350 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x;
TEST=strcat(num2str(0),',',num2str(0),',',num2str(50),',',num2str(0),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);
% --- Executes on button press in M390.
function M390_Callback(hObject, eventdata, handles)
% hObject    handle to M390 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
TEST=strcat(num2str(0),',',num2str(0),',',num2str(0),',',num2str(90),',',num2str(1),',',num2str(1));
fprintf(x,TEST);
pause(2);