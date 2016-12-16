close all
clear all
clc

listing = dir;
InputData = xlsread('Control_Group.xlsx','1U','B2:B76');

k = 0;

done = zeros(75,1);

for i = 1:length(listing)
    for ii = 1:length(InputData)
        
        check = listing(i).name;
        S = str2num(check(1:end-4));
        Cube = InputData(ii);
        
        if S == Cube 
           done(ii) = Cube; 
        end
        
        
    end
end

M = InputData-done;
final = M(M~=0);
