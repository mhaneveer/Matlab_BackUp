function [Mean_Motion, JD] = formatTLE(TLE_path)
fid = fopen(TLE_path,'r');
fseek(fid, 0, 'eof');
fileSize = ftell(fid);
frewind(fid);
data = fread(fid, fileSize, 'uint8');
numLines = sum(data == 10) +1
fclose(fid);

l1 = 1;
l2 = 1;

fid = fopen(TLE_path);
    
for i = 1 : numLines-1

    tline = fgets(fid);
    tline(1)
    i;
    
    if str2num(tline(1)) == 1  
    Line1 = sscanf(tline,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
    l1 = l1 + 1;
    
    line_num1       = Line1(1,1);
    sat_number1     = Line1(1,2);
    ID              = Line1(1,3);
    epoch           = Line1(1,4);
    mean_motion1    = Line1(1,5);
    mean_motion2    = Line1(1,6);
    BSTAR           = Line1(1,7)
    emphemeris      = Line1(1,8);
    element_number  = Line1(1,9);
    
    TLEf(i,:) = [line_num1, sat_number1, ID, epoch, mean_motion1, mean_motion2, BSTAR, emphemeris, element_number];
    end
    
    if str2num(tline(1)) == 2
    Line2 = sscanf(tline,'%d%6d%f%f%f%f%f%f%f',[1,8]);
    l2 = l2 + 1;;

    line_num2       = Line2(1,1);
    sat_number2     = Line2(1,2);
    inclination     = Line2(1,3);
    RAAN            = Line2(1,4);
    eccentricity    = Line2(1,5);
    arg_of_perigee  = Line2(1,6);
    mean_anomaly    = Line2(1,7);
    mean_motion     = Line2(1,8);
    
    Mean_Motion(i) = mean_motion;
    
    JD(i) = epoch;

    TLEf(i,:) = [line_num2, sat_number2, inclination, RAAN, eccentricity, arg_of_perigee, mean_anomaly, mean_motion, 0];

    end         
    
end
fclose(fid);    

TLEf(:,6);
%modifiedStr = strrep(TLE_path, 'Download', 'Formatted');
modifiedStr = strrep(TLE_path, '.txt', '_FORMAT.txt');


TLEfor = fopen(modifiedStr,'w+');
fprintf(TLEfor,'%4.4f  %4.4f   %4.4f       %4.4f     %4.4f    %4.4f %4.4f %4.4f %4.4f \n',TLEf');
fclose(TLEfor);   