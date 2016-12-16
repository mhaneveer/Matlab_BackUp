function [jdset, F107A, F107, APH] = getindices(jd,tstep,ndays)

%tstep is in minutes

jdset = jd + [0:tstep/1440:ndays];
[year,month,day,hour,minu,sec,dayweek,dategreg] = julian2greg(jdset');
bb = dategreg;
vv = [bb(:,3) bb(:,2)+1 bb(:,1) bb(:,4) bb(:,5) bb(:,6)];
vv(:,4:6) = 0;
vv0 = vv;
vv0(:,2:3) = 1;

dayOfYear = datenum(vv) - datenum(vv0) + 1 ;
UTseconds = bb(:,4).* 3600 +  bb(:,5).* 60 +  bb(:,6);

[F107A, F107, APH] = f107_aph(year,dayOfYear,UTseconds);


end