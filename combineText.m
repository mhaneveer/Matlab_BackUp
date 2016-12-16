close all
clear all
clc

listing = dir;

files = ['copy ' listing(3).name];

for i = 4:length(listing)
    files = [files  '+' listing(i).name ];
end

text = [files ' Cubes_1U_OE_Combined.txt'];
system(text)

fid = fopen('Cubes_1U_OE_Combined.txt','r');
fseek(fid, 0, 'eof');
chunksize = ftell(fid);
fseek(fid, 0, 'bof');
ch = fread(fid, chunksize, '*uchar');
k = sum(ch == sprintf('\n')); % k is number of lines 
fclose(fid);

fcontent = fileread('Cubes_1U_OE_Combined.txt');
fid = fopen('Cubes_1U_OE_Combined.txt', 'wt');
fwrite(fid, regexp(fcontent, '.*(?=\n.*?)', 'match', 'once'));
fclose(fid);