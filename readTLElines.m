function BSTAR = readTLElines(longstr1,longstr2)   

typerun = 'm';
deg2rad  =   pi / 180.0;         %  0.01745329251994330;  % [deg/rad]
    xpdotp   =  1440.0 / (2.0*pi);   % 229.1831180523293;  % [rev/day]/[rad/min]  

    revnum = 0; 
    elnum  = 0;
    year   = 0; 
    satrec.error = 0;

%     // set the implied decimal points since doing a formated read
%     // fixes for bad input data values (missing, ...)
    for (j = 11:16)
        if (longstr1(j) == ' ')
            longstr1(j) = '_';
        end
    end

    if (longstr1(45) ~= ' ')
        longstr1(44) = longstr1(45);
    end
    longstr1(45) = '.';
     
    if (longstr1(8) == ' ')
        longstr1(8) = 'U';
    end

    if (longstr1(10) == ' ')
        longstr1(10) = '.';
    end

    for (j = 46:50)
        if (longstr1(j) == ' ')
            longstr1(j) = '0';
        end
    end
    if (longstr1(52) == ' ')
        longstr1(52) = '0';
    end
    if (longstr1(54) ~= ' ')
        longstr1(53) = longstr1(54);
    end
    longstr1(54) = '.';

    longstr2(26) = '.';
     
    for (j = 27:33)
        if (longstr2(j) == ' ')
            longstr2(j) = '0';
        end
    end
     
    if (longstr1(63) == ' ')
        longstr1(63) = '0';
    end

    if ((length(longstr1) < 68) || (longstr1(68) == ' '))
        longstr1(68) = '0';
    end

    % parse first line
    carnumb = str2num(longstr1(1));
    satrec.satnum = str2num(longstr1(3:7));
    classification = longstr1(8);
    intldesg = longstr1(10:17);
    satrec.epochyr = str2num(longstr1(19:20));
    satrec.epochdays = str2num(longstr1(21:32));
    satrec.ndot = str2num(longstr1(34:43));
    satrec.nddot = str2num(longstr1(44:50));
    nexp = str2num(longstr1(51:52));
    satrec.bstar = str2num(longstr1(53:59));
    ibexp = str2num(longstr1(60:61));
    numb = str2num(longstr1(63));
    elnum = str2num(longstr1(65:68));
 
    % parse second line
    if (typerun == 'v')
        cardnumb = str2num(longstr2(1));
        satrec.satnum = str2num(longstr2(3:7));
        satrec.inclo = str2num(longstr2(8:16));
        satrec.nodeo = str2num(longstr2(17:25));
        satrec.ecco = str2num(longstr2(26:33));
        satrec.argpo = str2num(longstr2(34:42));
        satrec.mo = str2num(longstr2(43:51));
        satrec.no = str2num(longstr2(52:63));
        revnum = str2num(longstr2(64:68));
        startmfe = str2num(longstr2(70:81));        
        stopmfe  = str2num(longstr2(83:96)); 
        deltamin = str2num(longstr2(97:105)); 
    else
        cardnumb = str2num(longstr2(1));
        satrec.satnum = str2num(longstr2(3:7));
        satrec.inclo = str2num(longstr2(8:16));
        satrec.nodeo = str2num(longstr2(17:25));
        satrec.ecco = str2num(longstr2(26:33));
        satrec.argpo = str2num(longstr2(34:42));
        satrec.mo = str2num(longstr2(43:51));
        satrec.no = str2num(longstr2(52:63));
        revnum = str2num(longstr2(64:68));
    end
    
    BSTAR = satrec.bstar;
end