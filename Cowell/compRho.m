function rho = compRho(jdate,y)

global F107A F107 APH jdset

%r in km
r = [y(1); y(2); y(3)];

[latgc,latgd,lon,hellp] = ijk2ll (r);

jdate;
f= jdset;
val = jdate; %value to find
tmp = abs(f-val);
[idx idx] = min(tmp); %index of closest value
closest = f(idx); %closest value
row = idx;

%row = find( abs(jdate - jdset) <= 1e-1)
F107A0 = F107A(idx);
F1070  = F107(idx);
APH0 = APH(idx,:);

[year,month,day,hour,minu,sec,dayweek,dategreg] = julian2greg(jdset(row));
bb = dategreg;
vv = [bb(:,3) bb(:,2)+1 bb(:,1) bb(:,4) bb(:,5) bb(:,6)];
vv(:,4:6) = 0;
vv0 = vv;
vv0(:,2:3) = 1;

dayOfYear = datenum(vv) - datenum(vv0) + 1 ;
UTseconds = bb(:,4).* 3600 +  bb(:,5).* 60 +  bb(:,6);

alt = hellp * 1000;
lat = rad2deg(latgd);
long = rad2deg(lon);

flags = ones(1,23);
flags(9) = -1;

[T rho] = atmosnrlmsise00(alt, lat, long, year, dayOfYear, UTseconds,F107A0, F1070, ...  
APH0, flags, 'Oxygen', 'Warning');

rho = rho(6);



