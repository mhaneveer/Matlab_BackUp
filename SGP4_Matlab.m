% script testmat.m
%
% This script tests the SGP4 propagator.

% Author: 
%   Jeff Beck 
%   beckja@alumni.lehigh.edu 

% Version Info: 
%   1.0 (051019) - Initial version from Vallado C++ version. 
%   1.0 (aug 14, 2006) - update for paper
%   2.0 (apr 2, 2007) - update for manual operations
%   3.0 (3 jul, 2008) - update for opsmode operation afspc or improved
%   3.1 (2 dec, 2008) - fix tsince/1440.0 in jd update

function [tsince1,jd1,ro1,ro2,ro3,vo1,vo2,vo3,p1,a1,ecc1,incl1,node1,argp1,nu1,m1,arglat1,truelon1,lonper1] = SGP4_Matlab(TLE_path,typeinput,typerun,whichconst,mfe,TLEsteps)
   tott = 0;
   numA = 1;

   % these are set in sgp4init
   global tumin mu radiusearthkm xke j2 j3 j4 j3oj2  

   global opsmode

% // ------------------------  implementation   --------------------------

%   add operation smode for afspc (a) or improved (i)
    %opsmode= input('input opsmode afspc a, improved i ','s');

%         //typerun = 'c' compare 1 year of full satcat data
%         //typerun = 'v' verification run, requires modified elm file with
%         //typerun = 'm' manual operation- either mfe, epoch, or dayof yr
%         //              start stop and delta times
    %typerun = input('input type of run c, v, m: ','s');
    if (typerun == 'm')
        %typeinput = input('input mfe, epoch (YMDHMS), or dayofyr approach, m,e,d: ','s');
        typeinput = 'm';
    else
        typeinput = 'e';
    end;
        
   % whichconst = input('input constants 721, 72, 84 ');
    rad = 180.0 / pi;

%         // ---------------- setup files for operation ------------------
%         // input 2-line element set file
   % infilename = input('input elset filename: ','s');
   infilename = TLE_path;
    infile = fopen(infilename, 'r');
    if (infile == -1)
        fprintf(1,'Failed to open file: %s\n', infilename);
        return;
    end
    
%     if (typerun == 'c')
%         outfile = fopen('tmatall.out', 'wt');
%     else
%         if (typerun == 'v')
%             outfile = fopen('tmatver.out', 'wt');
%         else
%             outfile = fopen('tmat.out', 'wt');
%         end
%     end

    global idebug dbgfile

%        // ----------------- test simple propagation -------------------

    while (~feof(infile))
        longstr1 = fgets(infile, 130);
        while ( (longstr1(1) == '#') && (feof(infile) == 0) )
            longstr1 = fgets(infile, 130);
        end

        if (feof(infile) == 0)
            
            longstr2 = fgets(infile, 130);

    if idebug
        catno = strtrim(longstr1(3:7));
        dbgfile = fopen(strcat('sgp4test.dbg.',catno), 'wt');
        fprintf(dbgfile,'this is the debug output\n\n' );
    end
    
    if TLEsteps(1) == 0
    
%                // convert the char string to sgp4 elements
%                // includes initialization of sgp4
            [satrec, startmfe, stopmfe, deltamin] = twoline2rv( whichconst, ...
                       longstr1, longstr2, typerun, typeinput,mfe);

 %               // call the propagator to get the initial state vector value
            [satrec, ro ,vo] = sgp4 (satrec,  0.0);

            tsince = startmfe;

%                // check so the first value isn't written twice
            if ( abs(tsince) > 1.0e-8 )
                tsince = tsince - deltamin;
            end

%                // loop to perform the propagation
            while ((tsince < stopmfe) && (satrec.error == 0))

                tsince = tsince + deltamin;

                if(tsince > stopmfe)
                    tsince = stopmfe;
                end

                [satrec, ro, vo] = sgp4 (satrec,  tsince);
                if (satrec.error > 0)
                end  
                
                if (satrec.error == 0)
                    if ((typerun ~= 'v') && (typerun ~= 'c')) && (typerun ~= 'm')
                        jd = satrec.jdsatepoch + tsince/1440.0;
                        [year,mon,day,hr,minute,sec] = invjday ( jd );
                    else
                        
                        [p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper ] = rv2coe (ro,vo,mu);
                    end
                end %// if satrec.error == 0
                  
            tsince1(numA) = tsince;
            ro1(numA) = ro(1);
            ro2(numA) = ro(2);
            ro3(numA) = ro(3);
            vo1(numA) = vo(1);
            vo2(numA) = vo(2);
            vo3(numA) = vo(3);
            p1(numA) = p;
            a1(numA) = a;
            ecc1(numA) = ecc;
            incl1(numA) = incl;
            node1(numA) = node;
            argp1(numA) = argp;
            nu1(numA) = nu;
            m1(numA) = m;
            arglat1(numA) = arglat;
            truelon1(numA) = truelon;
            lonper1(numA) = lonper;
            
            jd1(numA) = satrec.jdsatepoch + tsince/1440.0;
            
            
            numA = numA + 1;
            
            end %// while propagating the orbit
            
            if (idebug && (dbgfile ~= -1))
                fclose(dbgfile);
            end
    end
   
   %satnum1(numA) = satrec.satnum;
    if TLEsteps(1) > 0
        
        %   // convert the char string to sgp4 elements
%           // includes initialization of sgp4
            [satrec, startmfe, stopmfe, deltamin] = twoline2rv( whichconst, ...
                       longstr1, longstr2, typerun, typeinput,mfe);

 %          // call the propagator to get the initial state vector value
            [satrec, ro ,vo] = sgp4 (satrec,  0.0);
            %
           
%             f = TLEsteps(:,1);
%             val = satrec.jdsatepoch;
%             tmp = abs(f-val);
%             [idx idx] = min(tmp); %index of closest value
%             closest = f(idx); %closest value
%             
%             rows = find(TLEsteps(:,1) == closest); % error with floating point -> absolute difference + error margin
            rows = find( abs(TLEsteps(:,1) - satrec.jdsatepoch) <= 1e-3);
            
            %rows = find(round(TLEsteps(:,1),1) == round(satrec.jdsatepoch,1));
            %tott = tott + length(rows)
            
            for i = length(rows):-1:1

                tsince = TLEsteps(rows(i),2)*1440;
                [satrec, ro, vo] = sgp4 (satrec,  tsince);
                
                if (satrec.error == 0)
                     if ((typerun ~= 'v') && (typerun ~= 'c')) && (typerun ~= 'm')
%                         jd = satrec.jdsatepoch + tsince/1440.0;
%                         [year,mon,day,hr,minute,sec] = invjday ( jd );
                    else
                        
                        [p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper ] = rv2coe (ro,vo,mu);
                    end
                end %// if satrec.error == 0
                  
            tsince1(numA) = tsince;
            ro1(numA) = ro(1);
            ro2(numA) = ro(2);
            ro3(numA) = ro(3);
            vo1(numA) = vo(1);
            vo2(numA) = vo(2);
            vo3(numA) = vo(3);
            p1(numA) = p;
            a1(numA) = a;
            ecc1(numA) = ecc;
            incl1(numA) = incl;
            node1(numA) = node;
            argp1(numA) = argp;
            nu1(numA) = nu;
            m1(numA) = m;
            arglat1(numA) = arglat;
            truelon1(numA) = truelon;
            lonper1(numA) = lonper;
            
            jd1(numA) = satrec.jdsatepoch + tsince/1440.0;
            %satnum1(numA) = 1;
            
            numA = numA + 1;
            
                
            
            end %// while propagating the orbit
            
            if (idebug && (dbgfile ~= -1))
                fclose(dbgfile);
            end
    end
    
    
    
        end %// if not eof
        
        

    end %// while through the input file

    fclose(infile);
%    fclose(outfile);
 

