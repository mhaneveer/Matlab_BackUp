function TLE2OEconversion(NORAD_ID)

retrieval_path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\SingleCubeSat\';
convert_path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\TLE_Download\OE_path\';

Controller = NORAD_ID;

listing = dir(convert_path);
for j = 4:length(listing)-1
   text(j) = str2num(listing(j).name(1:end-7));
end

if length(listing) == 2
    text = 1;
end

missingvalues = Controller(~ismember(Controller,text));

global whichconst mu
whichconst = 84;
[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(whichconst);

for i = 1:length(missingvalues)
    NORAD_ID = missingvalues(i);
   
TLE_path= [retrieval_path  num2str(NORAD_ID) '.txt'];

data=dir(TLE_path);

if data.bytes > 1

[jd, OE, eci] = TLE2OEv2(TLE_path);
ID = repmat(NORAD_ID,length(jd),1);

datawrite = [ID jd' OE eci];

dlmwrite([convert_path num2str(NORAD_ID) '_OE.txt'],...
    datawrite,'delimiter','\t','precision',10);

end
end