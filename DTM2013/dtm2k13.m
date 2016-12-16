function [outputdensity,outputtinf,outputtz,outputtp120,outputwmm,outputro_unc,outputd1,outputd2,outputd3,outputd4,outputd5,outputd6] = dtm2k13(alti,xlon,xlat,day,month,year,hour,minute,second)



%% Check for correct dates.

if datenum([year,month,day,hour,minute,second]) > datenum([2014 6 1 0 0 0]) % This hard-coded date may change.
    disp(['Choose another date.'])
return
end


%% Call the DTM-2013 function.

% Command-line formatting
    formatSpec = 'DTM2013.exe%12.1f%12.1f %12.1f %2i%2i %4i %2i %2i %12.9f';

% This output string can be pasted into the command window
    inputdata = sprintf(formatSpec,alti,xlon,xlat,day,month,year,hour,minute,second)

% Call the model
[status,cmdout] = system(inputdata);

% Format the results
    G = textscan(cmdout,'%f %f %f %f %f %f %f');
    outputs = G{1,1};

%% Output data.

% Density
    outputdensity = outputs(1);

% Others
    outputtinf = outputs(2);
    outputtz = outputs(3);
    outputtp120 = outputs(4);
    outputwmm = outputs(5);
    outputro_unc = outputs(6);

% Concentrations
    outputd1 = outputs(7);
    outputd2 = outputs(8);
    outputd3 = outputs(9);
    outputd4 = outputs(10);
    outputd5 = outputs(11);
    outputd6 = outputs(12);
end

