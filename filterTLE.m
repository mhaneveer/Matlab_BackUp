close all
clear all
clc

NORAD_ID    = 35005;
epoch_tot   = 200;
verificationTLE(NORAD_ID,epoch_tot)

global whichconst

whichconst = 84;
TLE_path= 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\TLE_Verification\Test.txt';

[jd, OE, eci] = TLE2OEv2(TLE_path);

for i = 1:length(jd)-1
    dM(i) = OE(i+1,6) - OE(i,6);
    dt(i) = abs((jd(i+1) - jd(i)) * 3600 * 24);
end

L = dt(dt>=3600*3);
M = dM(dt>=3600*3);

dM./dt;
%plot(OE(:,6))
plot(M./L)
grid on
