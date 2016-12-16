function [L1,L2] = dataTLE(fileID)
%Determine number of rows

fid = fopen(fileID,'r');
fseek(fid, 0, 'eof');
fileSize = ftell(fid);
frewind(fid);
data = fread(fid, fileSize, 'uint8');
numLines = sum(data == 10) + 1;
fclose(fid);

fid = fopen(fileID,'r');

l1 = 1;
l2 = 1;

for i = 1 : numLines-1
 
    tline = fgets(fid);
    
    if str2num(tline(1)) == 1  
    L1(l1,:) = tline;
    l1 = l1 + 1;
    
    end
    
    if str2num(tline(1)) == 2
    L2(l2,:) = tline;
    l2 = l2 + 1;
    end    
end
fclose(fid)