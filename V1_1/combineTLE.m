function combineTLE()

listing = dir('D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\TLE_Download\OE_path\');

files = ['copy ' listing(3).name];

for i = 4:length(listing)
    files = [files  '+' listing(i).name ];
end

cd('D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\TLE_Download\OE_path\');
text = [files ' TLE_OE_Combined.txt 1>NUL 2>NUL'];
system(text);

fid = fopen('TLE_OE_Combined.txt','r');
fseek(fid, 0, 'eof');
chunksize = ftell(fid);
fseek(fid, 0, 'bof');
ch = fread(fid, chunksize, '*uchar');
k = sum(ch == sprintf('\n')); % k is number of lines 
fclose(fid);

fcontent = fileread('TLE_OE_Combined.txt');
fid = fopen('TLE_OE_Combined.txt', 'wt');
fwrite(fid, regexp(fcontent, '.*(?=\n.*?)', 'match', 'once'));
fclose(fid);

movefile('TLE_OE_Combined.txt', ...
    'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE');