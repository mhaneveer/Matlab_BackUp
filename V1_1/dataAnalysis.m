function diff = dataAnalysis(NORAD_ID,days)

whichconst = 84;
[tumin, mu, radiusearthkm, xke, j2, j3, j4, j3oj2] = getgravc(whichconst);

verification_path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_Verification\';
propagation_path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\TUDAT\tudatBundle\tudatApplications\Application2\TemplateApplication\RK78';


for i = 1:length(NORAD_ID)

output_ver = dlmread([verification_path '\' num2str(NORAD_ID(i)) '_CART.txt']);
output_prop = dlmread([propagation_path '\RK78_' num2str(NORAD_ID(i)) '.dat']);

r_ver = [output_ver(:,2) output_ver(:,3) output_ver(:,4)] ;
v_ver = [output_ver(:,5) output_ver(:,6) output_ver(:,7)] ;
[a_ver,ecc,incl,omega,argp,nu,m,arglat,truelon,lonper ] = rv2orb (r_ver',v_ver',mu);
alt_ver  = a_ver  - radiusearthkm;

r_prop = [output_prop(:,2) output_prop(:,3) output_prop(:,4)] / 1000;
v_prop = [output_prop(:,5) output_prop(:,6) output_prop(:,7)] / 1000 ;
[a_prop,ecc,incl,omega,argp,nu,m,arglat,truelon,lonper ] = rv2orb (r_prop',v_prop',mu);
alt_prop  = a_prop  - radiusearthkm;
time_prop   = output_prop(:,1);

alt_prop  = alt_prop(alt_prop>=min(alt_ver));
time_prop = time_prop(alt_prop>=min(alt_ver)) / (24*3600) + 2451545 ;
time_ver  = output_ver(:,1);

diff(i,2) = time_ver(end) - time_prop(end);
diff(i,1) = NORAD_ID(i);

diff(i,3) = abs(diff(i,2) / days) * 100;

end
