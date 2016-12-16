function [CART_IC] = verificationTLE(NORAD_ID,total)

user  = 'maarten.haneveer@gmail.com';
pass  = 'maartenhaneveer1990';
URL='https://www.space-track.org/ajaxauth/login';
download_path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\TLE_Verification\';

    post={...
      'identity',user,...
      'password',pass,...
      'query',[...
        'https://www.space-track.org/basicspacedata/',...
        'query/class/tle/',...
        'NORAD_CAT_ID/',num2str(NORAD_ID),'/',...
        'orderby/EPOCH desc/limit/',num2str(total),'/'...
        'format/tle'
      ]...
    };

    out=urlread(URL,'Post',post,'Timeout',10);
    
    

    
    fid = fopen([download_path '\' num2str(NORAD_ID) '.txt'],'w+');
    fprintf(fid,'%s',out); 
    fclose(fid);   

    ICTLE = out(end-141:end-2);
    fid = fopen([download_path '\' num2str(NORAD_ID) '_IC.txt'],'w+');
    fprintf(fid,'%s',ICTLE); 
    fclose(fid);   
  
    
    

TLE_path = [download_path '\' num2str(NORAD_ID) '.txt'];
    
stepsize = 1         ; %minuten

mfe = [0.0 1.0 1.0];
typerun   = 'm';    
typeinput = 'm';
mfe = [0.0 1.0 1.0];

TLEsteps =[0 0];
whichconst = 72;

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
    
jd      = fliplr(jd);
ro1     = fliplr(ro1);
ro2     = fliplr(ro2);
ro3     = fliplr(ro3);
vo1     = fliplr(vo1);
vo2     = fliplr(vo2);
vo3     = fliplr(vo3);


r = [ro1; ro2; ro3]';
v = [vo1; vo2; vo3]';



datawrite = [jd' r v];
    
dlmwrite([download_path '\' num2str(NORAD_ID) '_CART.txt'],...
    datawrite,'delimiter','\t','precision',10);


TLE_path= [download_path '\' num2str(NORAD_ID) '_IC.txt'];

TLEsteps =[0 0];

[tsince,jd0, ro1,ro2,ro3,vo1,vo2,vo3, ... 
    p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper]...
    = SGP4_Matlab(TLE_path,typeinput,typerun,whichconst,mfe,TLEsteps);

J2000 = 2451545.0;
epochIC =  jd0 - J2000;

rIC = [ro1 ro2 ro3 ] * 1000;
vIC = [vo1 vo2 vo3 ] * 1000;

CART_IC = [rIC vIC epochIC];
    