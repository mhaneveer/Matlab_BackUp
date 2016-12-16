close all
clear all
clc

path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\EnhancedTLE\';
file = '39573.txt';

TLE_path = [path file];

clear m d tline A line1
m = 1;
d = fopen(TLE_path);
tline = fgetl(d);
while ischar(tline)
  str1 = tline;  
  %line1(m).data = tline;
  tline = fgetl(d);
  %A(m).data = tline;
  str2 = tline;
  BSTAR(m) = readTLElines(str1,str2)   ;
  m = m+1;
  clear tline
  tline = fgetl(d);
end


plot(BSTAR,'x')