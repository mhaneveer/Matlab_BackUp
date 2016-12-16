close all
clear all
clc

download_path  = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\SingleCubeSat\1U';
URL   = 'https://www.space-track.org/ajaxauth/login';
user  = 'maarten.haneveer@gmail.com';
pass  = 'maartenhaneveer1990';

[Cube_ID,Cube_name] = xlsread('Control_Group.xlsx','Cube_ID','A90:B214');
[Spheres_ID,Sphere_name] = xlsread('Control_Group.xlsx','Calibration_Spheres','A3:B22');
InputData = xlsread('Control_Group.xlsx','1U','B2:B96');

Controller = InputData;

listing = dir(download_path);
for j = 3:length(listing)-1
    text(j) = str2num(listing(j).name(1:end-4));
end

missingvalues = Controller(~ismember(Controller,text))

for i = 1:length(missingvalues)
    
NORAD_ID = missingvalues(i);
  
post={...
    'identity',user,...
    'password',pass,...
    'query',[...
            'https://www.space-track.org/basicspacedata/query/class/',...
            'tle/NORAD_CAT_ID/', num2str(NORAD_ID), '/orderby/EPOCH%20desc/format/tle'
            ]...
    };

out=urlread(URL,'Post',post);
    
fid = fopen([download_path '\' num2str(NORAD_ID) '.txt'],'w+');
fprintf(fid,'%s',out); 
fclose(fid);   

disp(sprintf('...Downloading TLE Data ID %d...',NORAD_ID))

clear fid out post
pause(2)

end
    