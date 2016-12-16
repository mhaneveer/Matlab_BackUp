function [OE_all] = plotTLEpoints(TLE_path)
tic
global whichconst tstep
stepsize = tstep;

typerun   = 'm';    
typeinput = 'm';
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%MFE SETTINGS%%%%
if typerun == 'c'
         startmfe =  -1440.0;
         stopmfe  =  1440.0;
         deltamin = 20.0;
         mfe = [startmfe stopmfe deltamin];
end

if typerun == 'm'
         startmfe =  0.0;
         stopmfe  =  1.0;
         deltamin = 1.0;
         mfe = [startmfe stopmfe deltamin];
end
%%%%%%%%%%%%%%%%%%%%

TLEsteps =[0 0];

[tsince,jd, ro1,ro2,ro3,vo1,vo2,vo3, ... 
    p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper]...
    = SGP4_Matlab(TLE_path,typeinput,typerun,whichconst,mfe,TLEsteps);

clear TLEsteps tsince 


minJD = min(jd);
timeframe = abs(max(jd)-min(jd));
steps = floor(timeframe * (1440/stepsize));

for i = 1: steps
    JD_extra(i) = minJD + (stepsize/1440) * i - (stepsize/1440);
end

flipJD = fliplr(jd);
jdo = 1;

for ii = 1:steps
       jd1 = flipJD(jdo);
       jd2 = flipJD(jdo+1);
       if JD_extra(ii) > jd1 + (abs(jd1-jd2)/2)
                  jdo = jdo + 1;  
                  jd1 = flipJD(jdo);
                  
                  if jdo == length(jd)
                      jd2 = flipJD(jdo) + 9999;

                      for j = ii:steps                       
                            epoch(j) = jd1;  
                            tsince(j)= JD_extra(j) - jd1;
                      end
                      break
                  end
                  
                jd2 = flipJD(jdo+1);
                  
                epoch(ii) = jd1;  
                tsince(ii)= JD_extra(ii) - jd1;           
       end
    
       if JD_extra(ii) <= jd1 + (abs(jd1 - jd2)/2)  
                epoch(ii) = jd1;  
                tsince(ii)= JD_extra(ii) - jd1;            
       end
end


TLEsteps = [epoch'  tsince'];
       
       [tsince,jd, ro1,ro2,ro3,vo1,vo2,vo3, ... 
        p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper]...
        = SGP4_Matlab(TLE_path,typeinput,typerun,whichconst,mfe,TLEsteps);
    
tsince  = fliplr(tsince);
jd      = fliplr(jd);
ro1     = fliplr(ro1);
ro2     = fliplr(ro2);
ro3     = fliplr(ro3);
vo1     = fliplr(vo1);
vo2     = fliplr(vo2);
vo3     = fliplr(vo3);
p       = fliplr(p);
a       = fliplr(a);
ecc     = fliplr(ecc);
incl    = fliplr(incl);
node    = fliplr(node);
argp    = fliplr(argp);
nu      = fliplr(nu);
m       = fliplr(m);
arglat  = fliplr(arglat);
truelon = fliplr(truelon);
lonper  = fliplr(lonper);



r = [ro1; ro2; ro3]';
v = [vo1; vo2; vo3]';

for i = 1:length(r)
[latgc(i),latgd(i),lon(i),hellp(i)] = ijk2ll ( r((i),:) );
[year(i),mon(i),day(i),hr(i),minute(i),sec(i)] = invjday ( jd(i) );
end
[year,month,day,hour,minu,sec,dayweek,dategreg] = julian2greg(jd');
date = datestr([jd-1721059.00000103]);

timeline = datenum(date);

OE_all = [a;ecc;incl;node;argp;m];

fprintf('\n  < Historical TLE Data Propagated >\n');
toc

end