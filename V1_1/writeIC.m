function [IC verOE JD0] = writeIC(database,NORAD_ID,days,beta)

for i = 1:length(NORAD_ID)
    
    filterTLE = ismember(database(:,1),NORAD_ID(i));

    indices = find(filterTLE==0);

    newDatabase = database;
    newDatabase(indices,:) = [];
    
    jdIC = max(newDatabase(:,2)) - days;
    
    tmp = abs(newDatabase(:,2)-jdIC);
    [idx idx] = min(tmp) ;
    IC(i,:) = newDatabase(idx,:);
    verOE =  newDatabase(1:idx,:);

    writePath= ['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_Verification\' num2str(NORAD_ID(i)) '_ver.txt'];
    dlmwrite(writePath, verOE,'delimiter','\t','precision',10);
    
end

J2000 = 2451545.0;
epochIC =  IC(:,2) - J2000;

JD0 = IC(:,2);

IC = [repmat(length(IC(:,2)),1,11); IC(:,1) IC(:,9:14)*1000 beta epochIC*24*3600]; 


TLE_path= 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\TUDAT\tudatBundle\tudatApplications\Application2\TemplateApplication\IC.txt';
dlmwrite(TLE_path, IC,'delimiter','\t','precision',10);