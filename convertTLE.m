function [OE] = convertTLE(TLE_path,mu)

fid = fopen(TLE_path,'r');
fseek(fid, 0, 'eof');
fileSize = ftell(fid);
frewind(fid);
data = fread(fid, fileSize, 'uint8');
numLines = sum(data == 10) + 1;
fclose(fid);
% Open the TLE file and read TLE elements
l1 = 1;
l2 = 1;
fid = fopen(TLE_path, 'rb');
for i = 1 : numLines
 
    tline = fgets(fid);
    
    if str2num(tline(1)) == 1  
    %L1(l1,:) = tline;
    Line1 = sscanf(tline,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
    l1 = l1 + 1;
    
    end
    
    if str2num(tline(1)) == 2
    %L2(l2,:) = tline;
    Line2 = sscanf(tline,'%d%6d%f%f%f%f%f%f%f',[1,8]);
    l2 = l2 + 1;
        
        epoch = Line1(1,4)*24*3600;        % Epoch Date and Julian Date Fraction
        Db    = Line1(1,5);                % Ballistic Coefficient
        inc   = Line2(1,3);                % Inclination [deg]
        RAAN  = Line2(1,4);                % Right Ascension of the Ascending Node [deg]
        e     = Line2(1,5)/1e7;            % Eccentricity 
        w     = Line2(1,6);                % Argument of periapsis [deg]
        M     = Line2(1,7);                % Mean anomaly [deg]
        n     = Line2(1,8);                % Mean motion [Revs per day]

        % Orbital elements

        a = (mu/(n*2*pi/(24*3600))^2)^(1/3);     % Semi-major axis [km]    

        % Calculate the eccentric anomaly using Mean anomaly
        err = 1e-10;            %Calculation Error
        E0 = M; t =1;
        itt = 0;
        while(t) 
              E =  M + e*sind(E0);
              if ( abs(E - E0) < err)
                  t = 0;
              end
              E0 = E;
              itt = itt+1;
        end

        % Six orbital elements 
        OE(i/2,:) = [epoch a e inc RAAN w E];
        
    end
          
end
fclose(fid);

% modifiedStr = strrep(TLE_path, 'Download', 'Converted');
% modifiedStr = strrep(modifiedStr, '.txt', '_OE.txt');
% 
% fid = fopen(modifiedStr,'w');
% fprintf(fid,'%4.2f  %4.4f   %4.4f       %4.4f     %4.4f    %4.4f \n',OE'); 
% fclose(fid);    