function [OE,eci,satrec] = TLE2OE(TLE_path)

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
    

            [satrec, startmfe, stopmfe, deltamin] = twoline2rv( whichconst, ...
                       longstr1, longstr2, typerun, typeinput,mfe);

            [satrec, ro ,vo] = sgp4 (satrec,  0.0);
            
                        if (idebug && (dbgfile ~= -1))
                fclose(dbgfile);
            end
        end
            
 end
fclose(infile);

[p,a,ecc,incl,node,argp,nu,m,arglat,truelon,lonper ] = rv2coe (ro,vo,mu);
OE = [a,ecc,incl,node,argp,m];
eci(:,1) = ro;
eci(:,2) = vo;
