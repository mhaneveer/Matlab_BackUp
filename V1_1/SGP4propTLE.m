function SGP4propTLE(NORAD_ID,startJD)


% NORAD_ID = 35004;
% jd = 2455799.036;

downloadPath = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\SingleCubeSat\';
verificationPath = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_Verification\';

for i = 1:length(NORAD_ID)
    ID = NORAD_ID(i);
    jd = startJD(i);
    [Y,M,D,H,MN,S,dayweek,dategreg] = julian2greg(jd);
    DateNumber = datenum(Y,M,D,H,MN,S);

    [doy,fraction] = date2doy(DateNumber);

    if Y >= 2000
        comp = (Y - 2000) * 1000 + doy;
    end

    if Y < 2000
        comp = (Y - 1900) * 1000 + doy;
    end

    TLE_path = [downloadPath num2str(ID) '.txt'];
    [epoch,row] = TLE2EPOCH(TLE_path);

    tmp = abs(epoch-comp);
    [idx idx] = min(tmp) ;
    deleteRow = row(idx)+1;

    str = fileread( TLE_path); 
    pos = strfind( str, sprintf('\n') );
    str( pos(deleteRow)-1 : pos(end))  = [];

    verPath = [verificationPath num2str(ID) '_ver.txt' ];

    fid = fopen( verPath, 'w' );
    fprintf( fid, '%s', str );
    fclose( fid );
end

disp('Succesfully modified TLE text file');
