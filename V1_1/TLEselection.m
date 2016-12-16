function newDatabase = TLEselection(NORAD_ID)

database = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\Cubes_TLE_OE_Combined.txt');
filterTLE = ismember(database(:,1),NORAD_ID);

indices = find(filterTLE==0);

newDatabase = database;
newDatabase(indices,:) = [];
end