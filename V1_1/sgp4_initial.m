close all
clear all
clc

verificationPath = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\TLE_JD_selection\TLE_JD_selection\';
TLE_path = [verificationPath 'NORAD60_year2000.txt'];
    
typerun   = 'm';    

whichconst = 84;

[saveJD jd savero savevo] = SGP4_batchTLE(TLE_path, typerun);   


clear TLEsteps tsince 

minJD = min(jd);
timeframe = abs(max(jd)-min(jd));
steps = floor(timeframe * 1440);

k = 1;
for i = 1:length(jd)
    
    if i == 1
        diffjd(k) = jd(k+1) - jd(k);
        midjd(k)  = (jd(k+1) + jd(k)) / 2;
        
        starttime(i) = 0;
        endtime(i)   = midjd(i) - jd(i);
        
        k = k + 1;
        continue
    end
    
    if i == length(jd)       
        starttime(i) = midjd(i-1) - jd(i);
        endtime(i) = 0;
        break
    end
    
    diffjd(k) = jd(k+1) - jd(k);
    midjd(k)  = (jd(k+1) + jd(k)) / 2;
    
    starttime(i) =  midjd(i-1) - jd(i);
    endtime(i)   =  midjd(i)   - jd(i);
    
    
    k = k + 1;
end

startmfe = round(starttime .* 1440);
endmfe   = round(endtime   .* 1440);


clear m d tline A line1
m = 1;
d = fopen([verificationPath 'TLE_60_asc_yr_2000.txt']);
%d = fopen('test9.txt');
tline = fgetl(d);
while ischar(tline)
  line1(m).data = tline;
  tline = fgetl(d);
  A(m).data = tline;
  m = m+1;
  clear tline
  tline = fgetl(d);
end

fclose(d);

% Preallocate B to a cell array
B = cell(length(A),11);
B_line1 = cell(length(line1),9);
for n = 1:length(A)
    % Replace the , with .
    B(n,1:8) = strsplit(strrep(A(n).data,',','.'));
    B_line1(n,1:9) = strsplit(strrep(line1(n).data,',','.'));
    B(n,9) = cellstr(num2str(startmfe(n),'%011d'));
    B(n,10) = cellstr(num2str(endmfe(n),'%012d'));
    B(n,11) = cellstr(num2str(1,'%08d'));
end

C = cell2struct(B,'data',9)
C_line1 = cell2struct(B_line1,'data',9)

for i = length(C)
    C(i,9).data = num2str(C(i,9).data);
    C(i,10).data = num2str(C(i,10).data)
    C(i,11).data = num2str(C(i,11).data)
end


s = C;
s_line1 = C_line1
txt = struct2cell(arrayfun(@(x) structfun(@num2str,x,'UniformOutput',false),s));
txt_line1 = struct2cell(arrayfun(@(x) structfun(@num2str,x,'UniformOutput',false),s_line1));



for k=1:length(s) % Dump rows to the file. Every struct entry is a line into the file 
    
characterCell = {'+'};    
check7 = cellfun(@(x) x(1:end-7), txt_line1(1,k,7), 'un', 0);
[~,index7] = ismember(characterCell,check7);    
if index7 == 1
    txt_line1(1,k,7) = cellfun(@(x) x(2:end), txt_line1(1,k,7), 'un', 0);
end
 
    
formRow=squeeze((strcat(txt(:,k,:),''))); 
formRow_line1=squeeze((strcat(txt_line1(:,k,:),''))); 



plus_check=txt_line1(1,k,6);
B = cellfun(@(x) x(1:end-7), plus_check, 'un', 0);
[~,index] = ismember(characterCell,B);

plus_check1=txt_line1(1,k,5);
X = cellfun(@(x) x(1:end-9), plus_check1, 'un', 0);
[~,index1] = ismember(characterCell,X);

fid = fopen('measurementLogFiles.txt','a+'); 

if index == 1 && index1 == 1
    fprintf(fid,'%s %s %s   %s %s %s  %s %s  %s\n',formRow_line1{:}); 
    fprintf(fid,'%s %s %s %s %s %s %s %s %s  %s %s\n',formRow{:}); 
end

if index == 1 && index1 == 0
    fprintf(fid,'%s %s %s   %s  %s %s  %s %s  %s\n',formRow_line1{:}); 
    fprintf(fid,'%s %s %s %s %s %s %s %s %s  %s %s\n',formRow{:}); 
end

if index == 0 && index1 == 1
    fprintf(fid,'%s %s %s   %s %s  %s  %s %s  %s\n',formRow_line1{:}); 
    fprintf(fid,'%s %s %s %s %s %s %s %s %s  %s %s\n',formRow{:}); 
end

if index == 0 && index1 == 0
    fprintf(fid,'%s %s %s   %s  %s  %s  %s %s  %s\n',formRow_line1{:}); 
    fprintf(fid,'%s %s %s %s %s %s %s %s %s  %s %s\n',formRow{:});
end
fclose(fid); 
end

%%

clear all
fclose('all')

typerun   = 'v';    
TLE_path  = 'measurementLogFiles.txt';
[saveJD jd savero savevo] = SGP4_batchTLE(TLE_path, typerun);   

%%

dlmwrite(['D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\Figure4_Picone\RV_60_ECEF_asc_yr_2000_teme_12_dec.txt'], ...
    [saveJD savero savevo] ,'delimiter','\t','precision',20);
