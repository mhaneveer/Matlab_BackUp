close all
clear all
clc

w = warning ('off','all');

global whichconst 
whichconst = 84;
[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(whichconst);

sgp4Data     = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\Figure4_Picone\RV_60_ECEF_asc_yr_2000_teme_12_dec.txt')  ;
rhoData      = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\Figure4_Picone\rho_60_asc_yr_2000_teme.txt')      ;
OEData       = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Verify\Data\OE_60_asc_yr_2000.txt')       ;
F            = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\Figure4_Picone\windfactor.txt') ;
V_norm       = dlmread('D:\Documents\TU_Delft\MSc\Thesis\02_Program\UnitTests\Figure4_Picone\v_norm.txt') ;

%%
close all
clear jd rho r_ecef v_ecef V_tot R_tot jdTLE mmTLE u
clear jdSet mmSet
clear out_corr out

jd  = sgp4Data(:,1);                            %seconds(conversion later)
rho = rhoData(:,6);                             %kg/m3
r_ecef   = sgp4Data(:,2:4) .* 1000;             %m
v_ecef   = sgp4Data(:,5:7) .* 1000;             %m/s
V_tot  = V_norm.* 1000;                         %m/s
R_tot  = sqrt(r_ecef(:,1).^2 + r_ecef(:,2).^2 + r_ecef(:,3).^2) .* 1000;    %m/s

jdTLE = OEData(:,2);            %seconds(conversion later)
mmTLE = OEData(:,8);            %rad/min

u = mu * 1e9 * 3600;            %m3 / min2

k = 1;

TLEdays = 3;

for i = 1:length(jdTLE)
    
    clear tmp
    
    jdNext     = jdTLE(i) + TLEdays       ;

    if jdNext > max(jdTLE)
        break
    end
    
    tmp        = jdTLE-jdNext          ;
    tmp(tmp<0) = inf                   ;
    [idx idx]  = min(tmp)              ;
    jdSet(k,:) = [jdTLE(i) jdTLE(idx)] ;
    mmSet(k,:) = [mmTLE(i) mmTLE(idx)] ;
    
    k = k + 1;

end

betaT =  0.0232;  %m2/kg
    
for i = 1:length(jdSet)

    jd1          = jdSet(i,1)  ;
    jd2          = jdSet(i,2)  ;
    tmp1         = abs(jd-jd1) ;
    tmp2         = abs(jd-jd2) ;
    [idx1 idx1]  = min(tmp1)   ;
    [idx2 idx2]  = min(tmp2)   ;
    
    rhoTLE = rho(idx1:idx2);
    vTLE   = V_tot(idx1:idx2);
    FTLE   = F(idx1:idx2);
    
    diffJD = (jd(idx2) - jd(idx1)) * 1440;      %minutes
  
    mm1  = (mmSet(i,1)) ; 
    mm2  = (mmSet(i,2)) ; 
    
    mm_av  = (mm1 + mm2) / 2;
    diffmm = mm2 - mm1;
       
    numerator(i)   = (2/3) * u^(2/3) * mm_av^(-1/3)  * diffmm;  
    denominator(i) = sum( rhoTLE.* FTLE .* (vTLE * 60).^3); 
  
    out(i)  = numerator(i) / denominator(i);
    
end

out_corr  = out ./ betaT;

[year,month,day,hour,minu,sec,dayweek,dategreg] = julian2greg(jdSet(:,1)');
date = datestr([jdSet(:,1) - 1721059.00000103]);
timeline = datenum(date);
[doy,fraction] = date2doy(timeline);

x = linspace(0,365,length(out_corr));

% figure(2)
% plot(doy(2:end)',out_corr(2:end))
% grid on
% xlabel('Day of Year 2000')
% ylabel('')
% axis([min(doy) max(doy) min(out_corr) max(out_corr)])
% hold on
% plot(doy(2:end)',repmat(1,1,length(out_corr)-1))

figure(2)
plot(x,out_corr)
set(gca,'xtick',[0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360]);
grid on
xlabel('Day of Year 2000')
ylabel('')
axis([min(doy) max(doy) 0.5 1.5])
hold on
plot(x,repmat(1,1,length(out_corr)))
