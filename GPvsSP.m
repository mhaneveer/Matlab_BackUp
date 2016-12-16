close all
clear all
clc
tic

tstart = tic;

global mu whichconst lgrav mgrav
global tstep
global F107A F107 APH jdset

whichconst = 84;        
lgrav = 18;
mgrav = 18;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    Input TLE and stepsizes         %%%%%%%%%%%%%
NORAD_ID    = 35005;
epoch_tot   = 13 ;
%verificationTLE(NORAD_ID,epoch_tot)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    Input TLE and stepsizes         %%%%%%%%%%%%%

TLE_all  = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\TLE_Verification\Test.txt';
TLE_path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\TLE_Verification\TestIC.txt';
ndays = 5;                     %Number of days to be propagated
tstep = 1;                      %Stepsize in minutes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    Initial OE and Grav. Model      %%%%%%%%%%%%%

[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(whichconst);
[OE,eci,satrec] = TLE2OE(TLE_path);
[OE_all] = plotTLEpoints(TLE_all);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%            SGP4 Propagation        %%%%%%%%%%%%%

tsince = [0:tstep:1440 * ndays];
[pGP,aGP,eccGP,inclGP,omegaGP,argpGP,nuGP,mGP,arglatGP,truelonGP,lonperGP] = SGP4singleTLE(satrec,tsince);
%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    SP RK 78 Cowell's Propagation   %%%%%%%%%%%%%

[jdset, F107A, F107, APH] = getindices(satrec.jdsatepoch,tstep,ndays);

[xdata ydata] = propSP(satrec.jdsatepoch,ndays,tstep,OE,eci);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%         Graphical Results          %%%%%%%%%%%%%
%%
figure(1)
plot(aGP-radiusearthkm )
hold on
plot(ydata(1, :)-radiusearthkm );
plot(OE_all(1,:)-radiusearthkm );
grid on
legend('SGP4', 'Cowells', 'TLE Data')

tfinal = toc(tstart)

