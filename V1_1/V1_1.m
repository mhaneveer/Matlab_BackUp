close all
clear all
clc

warning('off','MATLAB:nargchk:deprecated')

propagation_days = 20;
dlmwrite('D:\Documents\TU_Delft\MSc\Thesis\02_Program\TUDAT\tudatBundle\tudatApplications\Application2\TemplateApplication\settings.txt',...
    propagation_days * 2);

InputData = xlsread('Control_Group.xlsx','TestGroup','B18:E20');
NORAD_ID  = InputData(:,1);
beta      = [InputData(:,4) InputData(:,2) InputData(:,3)];

database = createDatabase(NORAD_ID);
[NORAD_ID] = verifyDays(database, propagation_days);

k = 1;
for i = 1:length(NORAD_ID)
    if ismember(NORAD_ID(i),InputData(:,1)) == 1
        line = find(InputData(:,1) == NORAD_ID(i));
        beta_out(k,:) = beta(line,:);
        k = k + 1;
    end
end

[IC ver_OE JD0] = writeIC(database,NORAD_ID,propagation_days,beta_out);

disp('TUDAT application can be started');

SGP4propTLE(NORAD_ID,JD0);

tic
for i = 1:length(NORAD_ID)
    NORAD_in = NORAD_ID(i);
    sgpTLE(NORAD_in);
end
toc
%%
plotSATS(NORAD_ID)
diff = dataAnalysis(NORAD_ID,propagation_days)

dlmwrite(['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Results\' num2str(date) '-' num2str(5) '.txt'], ...
    [diff beta_out repmat(propagation_days,size(beta_out,1),1)] ,'delimiter','\t','precision',10);
