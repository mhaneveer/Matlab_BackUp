function [NORAD_ID_out] = verifyDays(database, days)

NORAD_ID = unique(database(:,1));
NORAD_ID_out = 0;
k = 1;

for i = 1:length(unique(database(:,1)))
    
    clear new setTLE findTLE checkDays

    findTLE = ismember(database(:,1),NORAD_ID(i));
    
    new = find(findTLE==0);
    setTLE = database;
    setTLE(new,:) = [];
    
    checkDays(1) = min(setTLE(:,2));
    checkDays(2) = max(setTLE(:,2));
    
    if (checkDays(2) - checkDays(1)) >= days
        NORAD_ID_out(k) = unique(setTLE(:,1));
        k = k + 1;
    end
end
