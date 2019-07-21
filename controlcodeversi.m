clc
clear all;
global x y;
%%
%characteristics of the robot arm.
X=27.5; %cm
Y=50;%cm
Z=17;%cm
h=10;%cm
dx=3.3; % the unit is cm
dy=3.6;%the unit is cm
L1=32; %the unit is cm
L2=35;%the unit is cm
m=11;
n=8;
dt=1;% the unit is second

%%
%joint matrics defination
joint0=zeros(n,m);
joint1=zeros(n,m);
joint2=zeros(n,m);
joint3=zeros(n,m);
joint1_1=zeros(n,m);
joint2_1=zeros(n,m);
joint3_1=zeros(n,m);
%%
%for loop calculation of joint position
for i=1:m
for j=1:n
joint0(i,j)=rad2deg(atan((Y-(i-1)*dy)/(X-(j-1)*dx)));
%joint position of measurement
L3=sqrt((Y-(i-1)*dy)^2+(X-(j-1)*dx)^2+Z^2);
joint1(i,j)=rad2deg(acos((L1^2+L3^2-L2^2)/(2*L1*L3)));
joint2(i,j)=rad2deg(acos((L1^2+L2^2-L3^2)/(2*L1*L2)));
joint3(i,j)=rad2deg(acos((L2^2+L3^2-L1^2)/(2*L2*L3)))+rad2deg(atan((Z)/(sqrt(X^2+Y^2))))+90;
%mines the calibration angle
joint1(i,j)=joint1(i,j)-64;
joint2(i,j)=joint2(i,j)-64;
joint3(i,j)=joint3(i,j)-180;
% transitional position
L3_1=sqrt((Y-(i-1)*dy)^2+(X-(j-1)*dx)^2+(Z-h)^2);
joint1_1(i,j)=rad2deg(acos((L1^2+L3_1^2-L2^2)/(2*L1*L3_1)));
joint2_1(i,j)=rad2deg(acos((L1^2+L2^2-L3_1^2)/(2*L1*L2)));
joint3_1(i,j)=rad2deg(acos((L2^2+L3^2-L1^2)/(2*L2*L3)))+rad2deg(atan((Z)/(sqrt(X^2+Y^2))))+90;
%after calibration
joint1_1(i,j)=joint1_1(i,j)-64;
joint2_1(i,j)=joint2_1(i,j)-64;
joint3_1(i,j)=joint3_1(i,j)-180;
end
end
%%
%disp the results of calcualtion
disp("joint0=");
disp(joint0);
disp("joint1=");
disp(joint1);
disp("joint1_1=");
disp(joint1_1);
disp("joint2=");
disp(joint2);
disp("joint2_1=");
disp(joint2_1);
disp("joint3=");
disp(joint3);
disp("joint3_1=");
disp(joint3_1);

%%
%comunication check
disp("Communication requist...");
x=serial('COM4','BAUD',9600);
fopen(x);
ComRequist = "0";
fprintf(x,ComRequist);
delay(100);
y=fscanf(x);
%disp the check result
if y==1
    disp("Communication success");
else
    disp("Communication fail");
end

%%
%begin to send the data
    %TP is transitional position data
    %MP is measurement position data
    %sw is the air generator switch 0 is close, 1 is open
%scan the right half page
for i=1:m
for j=1:n
sw=0;   
MP=strcat(num2str(joint0(i,j)),',',num2str(joint1(i,j)),',',num2str(joint2(i,j)),',',num2str(joint3(i,j)),',',num2str(dt),',',num2str(sw));
TP=strcat(num2str(joint0(i,j)),',',num2str(joint1_1(i,j)),',',num2str(joint2_1(i,j)),',',num2str(joint3_1(i,j)),',',num2str(dt),',',num2str(sw));
fprintf(x,TP);
fprintf(x,MP);
fprintf(x,TP);
end
end

%scan the left half page
for i=1:m
for j=1:n
sw=0;   
MP=strcat(num2str(180-joint0(i,j)),',',num2str(joint1(i,j)),',',num2str(joint2(i,j)),',',num2str(joint3(i,j)),',',num2str(dt),',',num2str(sw));
TP=strcat(num2str(180-joint0(i,j)),',',num2str(joint1_1(i,j)),',',num2str(joint2_1(i,j)),',',num2str(joint3_1(i,j)),',',num2str(dt),',',num2str(sw));
fprintf(x,TP);
fprintf(x,MP);
fprintf(x,TP);
end
end
 
%flip page
sw=0;
Pose1=strcat(num2str(180-joint0(i,j)),',',num2str(joint1(i,j)),',',num2str(joint2(i,j)),',',num2str(joint3(i,j)),',',num2str(dt),',',num2str(sw));
Pose2=strcat(num2str(180-joint0(i,j)),',',num2str(joint1(i,j)),',',num2str(joint2(i,j)),',',num2str(joint3(i,j)),',',num2str(dt),',',num2str(sw));
Pose3=strcat(num2str(180-joint0(i,j)),',',num2str(joint1(i,j)),',',num2str(joint2(i,j)),',',num2str(joint3(i,j)),',',num2str(dt),',',num2str(sw));
fprintf(x,Pose1);
fprintf(x,Pose2);
fprintf(x,Pose3);

%calibrition sensor
%the calibration position is 0,64,64,180
sw=0;
CA=strcat(num2str(0),',',num2str(64),',',num2str(64),',',num2str(180),',',num2str(5),',',num2str(sw));
fprintf(x,CA);
y=fscanf(x);
if y==2
    disp("Scan finished");
end
disp("Stop sending the requist");
