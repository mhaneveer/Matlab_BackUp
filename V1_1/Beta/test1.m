close all
clear all
clc
tic

w = warning ('off','all');

global whichconst 
whichconst = 84;
[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(whichconst);

NORAD_ID = 60;
% path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Test\60test.txt';
% [jd, OE, eci] = TLE2OEv2(path);
% database = [repmat(NORAD_ID,length(jd),1),jd',OE,eci];
% 
% datawrite = lowerTest(NORAD_ID);
% 
% %IN DATABASE
% %(3) semi-major axis
% %(4) eccentriciy
% %(5) inclination
% %(6) RAAN
% %(7) Mean Anomaly
% %(8) Mean Motion 
% 
% %IN DATAWRITE
% %(1) JD
% %(2-4) R
% %(5-7) V
% %(8) incl
% 
% jd_sgp = datawrite(:,1);
% r = datawrite(:,2:4);
% v = datawrite(:,5:7);
% incl = datawrite(:,8);
% 
% toc
%

sgp4Data = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60SGP4.txt');
%rhoData  = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60rho.txt');
OEData   = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60OEtest.txt');
ECEFdata = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60_rv_ecef_mat.txt');

jd      = sgp4Data(:,1);
r_eci   = sgp4Data(:,2:4);
v_eci   = sgp4Data(:,5:7);
inc_eci = sgp4Data(:,8);
%%
for i = 1:length(ECEFdata)
    [latgc(i),latgd(i),lon(i),hellp(i)] = ijk2ll ( ECEFdata((i),2:4) );
    v_tot(i) = norm(ECEFdata(i,5:7));
end
%%
geoshow(latgd(2:400),lon(2:400));
plot(rad2deg(lon(1:1400)),rad2deg(latgd(1:1400)),'*')

%%

for i = 1:length(sgp4Data)
    [Y(i),M(i),D(i),H(i),MN(i),S(i)] = julian2greg(sgp4Data(i,1));
    dcm = dcmeci2ecef('IAU-2000/2006',[Y(i),M(i),D(i),H(i),MN(i),S(i)]);
    
    r_ecef(i,:) = r_eci(i,:) * dcm;
    v_ecef(i,:) = v_eci(i,:) * dcm;
    %[r_ECEF(i,:) v_ECEF(i,:) a_ECEF(i,:) ] = ECItoECEF(sgp4Data(i,1),r(i,:)',v(i,:)', repmat(0,1,3)');
    
end
%%
dlmwrite(['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60_rv_ecef_mat.txt'], ...
    [sgp4Data(:,1), r_ecef, v_ecef] ,'delimiter','\t','precision',20);

%%

timeline = datenum(sgp4Data(:,1) - 1721059.00000103);
[doy,fraction] = date2doy(timeline);

[F107A, F107, APH] = f107_aph(Y',round(doy),repmat(0,1,length(Y)));

%dlmwrite(['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60f107.txt'], ...
  %  [sgp4Data(:,1), F107A, F107, APH ] ,'delimiter','\t','precision',20);


flags = ones(1,23);
flags(9) = -1;
tic

for i = 1:length(r_ecef)
[latgc(i),latgd(i),lon(i),hellp(i)] = ijk2ll (r_ecef(i,:));
end

alt = hellp * 1000;
lat = rad2deg(latgd);
long = rad2deg(lon);

%
%dlmwrite(['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60RV_ECEF.txt'], ...
 %   [r_ECEF v_ECEF] ,'delimiter','\t','precision',20);

%
tic
for i = 1 : length(r_ecef)

    [T(i,:) rho(i,:)] = atmosnrlmsise00(alt(i), lat(i),long(i), Y(i), doy(i),0,F107A(i), F107(i), ...  
    APH(i,:), flags, 'Oxygen', 'None');
                    
end
toc

dlmwrite(['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\60rho_ECEF.txt'], ...
    rho ,'delimiter','\t','precision',20);
%%

v_tot = sqrt(v(:,1).^2 + v(:,2).^2 + v(:,3).^2);

rho_tot = rho(:,6); %Total mass density, in kg/m3
djd =( database(1,2)-database(end,2)) * 86400;    
lower = rho_tot(1:end) .* F(1:end)' .* (v_tot * 1000).^3; 
sum_lower = sum(lower) / djd;
%%
u = mu * 10^9;
n1 = database(end,8);

dn1 = database(1,8)-database(end,8);
t_av = djd / 2;
n_2 = (database(1,8) + database(end,8)) / 2;


upper = (2/3) * u ^ (2/3) * [n_2] ^(-1/3)  * dn1;

out = upper / sum_lower
out = out * 1000
