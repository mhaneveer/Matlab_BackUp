function [jd, OE, eci] = TLE2OEv2(TLE_path)

global mu whichconst
global idebug dbgfile

typerun   = 'c';    
typeinput = 'm';

         startmfe =  -1440.0;
         stopmfe  =  1440.0;
         deltamin = 20.0;
         mfe = [startmfe stopmfe deltamin];



   infilename = TLE_path;
    infile = fopen(infilename, 'r');
    if (infile == -1)
        fprintf(1,'Failed to open file: %s\n', infilename);
        return;
    end
i = 0;
 while (~feof(infile))
        longstr1 = fgets(infile, 130);
        while ( (longstr1(1) == '#') && (feof(infile) == 0) )
            longstr1 = fgets(infile, 130);
        end

        if (feof(infile) == 0)
            
            longstr2 = fgets(infile, 130);
            %disp(longstr1)
            i = i+1;

    if idebug
        catno = strtrim(longstr1(3:7));
        dbgfile = fopen(strcat('sgp4test.dbg.',catno), 'wt');
        fprintf(dbgfile,'this is the debug output\n\n' );
    end
    

            [satrec, startmfe, stopmfe, deltamin] = twoline2rv( whichconst, ...
                       longstr1, longstr2, typerun, typeinput,mfe);
            
            [satrec, ro ,vo] = sgp4 (satrec,  0.0);

                        if (idebug && (dbgfile ~= -1))
                fclose(dbgfile);
            end
        end
            meanMotion = satrec.no;
            [p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper ] = rv2coe (ro,vo,mu);
            OE(i,:) = [a,ecc,incl,node,m,meanMotion];  %semi-major axis, eccentriciy, inclination, RAAN, Mean Anomaly, mean motion 
            eci(i,:) = [ro vo];
            jd(i) = satrec.jdsatepoch;
 end
fclose(infile);


end