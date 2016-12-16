close all
clear all
clc


%fid = fopen('3Line_Full_Catalog.txt','rb');
fid = fopen('cubesatTLE.txt','rb');


l1=1;
l2=1;
l3=1;

fseek(fid, 0, 'eof');
fileSize = ftell(fid);
frewind(fid);
data = fread(fid, fileSize, 'uint8');
%# Count number of line-feeds and increase by one.
numLines = sum(data == 10) + 1;
fclose(fid);

[Cube_ID,Cube_name] = xlsread('Control_Group.xlsx','Cube_ID','A2:B214');
[Spheres_ID,Sphere_name] = xlsread('Control_Group.xlsx','Calibration_Spheres','A3:B20');


%fid = fopen('3Line_Full_Catalog.txt','rb');
fid = fopen('cubesatTLE.txt','rb');

L1 = blanks(24);


for i = 1 : numLines-1
 
    tline = fgets(fid);
    tline(1);
    
 
    
    if str2num(tline(1)) == 1  
    L2(l2,:) = tline;
    l2 = l2 + 1;
    
    end
    
    if str2num(tline(1)) == 2
    L3(l3,:) = tline;
    l3 = l3 + 1;
    end
    
    if ischar(tline(1)) == 1 %& str2num(tline(1)) ~= 2
    L1(l1,1:length(tline)) = tline;
    l1 = l1 + 1;
    end
end
fclose(fid);

%%
SATCAT          = L1(:,3:24);

sat_number1     = str2num(L2(:,3:7));
classification  = L2(:,8);
ID              = L2(:,10:17);
epoch           = str2num(L2(:,19:32));
mean_motion1    = str2num(L2(:,34:43));
mean_motion2    = str2num(L2(:,45:52));
BSTAR           = (L2(:,54:61));
emphemeris      = str2num(L2(:,63));
element_number  = str2num(L2(:,65:68));

sat_number2     = str2num(L3(:,03:07));
inclination     = str2num(L3(:,09:16));
RAAN            = str2num(L3(:,18:25));
eccentricity    = (L3(:,27:33));
arg_of_perigiee = (L3(:,35:42));
mean_anomaly    = (L3(:,44:51));
mean_motion     = (L3(:,53:63));
rev_number      = str2num(L3(:,64:68));

