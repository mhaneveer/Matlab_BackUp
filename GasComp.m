close all
clear all
clc

alt = 100000:1000:1000000;
alt = 400000;
lat = 0;
long = 0;
year = 2000;
dayOfYear  = 1:365;
UTseconds  = 40000;

for i = 1:length(dayOfYear)
    year0(i) = year;
    UTseconds0(i) = UTseconds;
    lat0(i) = lat;
    long0(i) = long;
    alt0(i) = alt;
end
[F107A, F107, APH] = f107_aph(year0,dayOfYear,UTseconds0);
%%
plot(F107)
grid on

%%
flags = ones(1,23);
flags(9) = -1;

[T rho] = atmosnrlmsise00(alt0, lat0, long0, year0, dayOfYear, UTseconds0,F107A, F107, ...  
APH, flags, 'Oxygen', 'None');


%rho(1,:)
%rho=log10(rho)

O2 = log10(rho(:,4)); 
N2 = log10(rho(:,3));
O  = log10(rho(:,2));
He = log10(rho(:,1));
H  = log10(rho(:,7));
% O2 = (rho(:,4)); 
% N2 = (rho(:,3));
% O  = (rho(:,2));
% He = (rho(:,1));
% H  = (rho(:,7));
% Total = rho(:,6);
Total = log10(rho(:,4) + rho(:,3) + rho(:,2) + rho(:,1) + rho(:,7));

alt = alt / 1000;
%%
plot(dayOfYear,O2)
hold on
plot(dayOfYear,N2)
plot(dayOfYear,O)
plot(dayOfYear,He)
plot(dayOfYear,H)
plot(dayOfYear,Total)
axis ([0 365 min(H) max(Total)])
grid on
legend('O2', 'N2', 'O', 'He', 'H' ,'Total')
