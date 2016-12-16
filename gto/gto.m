% gto.m          May 22, 2013

% long-term evolution of geosynchronous transfer orbits

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global dtr rtd atr req mu omega

global j2 lgrav mgrav isun imoon

global jdate0 gst0

global rkcoef ccoef scoef

% astrodynamic and utility constants

om_constants;

atr = dtr / 3600.0;

% initialize rkf78 integrator

rkcoef = 1;

% define number of differential equations

neq = 6;

% read gravity model coefficients

gmfile = 'egm96.dat';

[ccoef, scoef] = readgm(gmfile);

% extract j2 coefficient

j2 = -ccoef(3, 1);

if (strcmp(gmfile, 'egm96.dat'))
    
    % egm96 constants
    
    mu = 398600.4415;
    
    req = 6378.1363;
    
    omega = 7.292115e-5;
    
end

% begin simulation

clc; home;

fprintf('\n program gto\n');

fprintf('\n < long-term evolution of geosynch transfer orbits >\n');

% request initial calendar date and time

fprintf('\ninitial calendar date and UTC time\n');

[month, day, year] = getdate;

[uthr, utmin, utsec] = gettime;

while (1)
    
    fprintf('\nplease input the simulation period (days)\n');
    
    ndays = input('? ');
    
    if (ndays > 0)
        break;
    end
    
end

tsim = 86400.0 * ndays;

while (1)
    
    fprintf('\nplease input the algorithm error tolerance');
    fprintf('\n(a value between 1.0e-8 and 1.0e-12 is recommended)\n');
    
    tetol = input('? ');
    
    if (tetol > 0)
        
        break;
        
    end
    
end

% request degree and order of gravity model

fprintf('\n\ngravity model inputs \n');

while(1)
    
    fprintf('\nplease input the degree of the gravity model (zonals)\n');
    fprintf('(0 <= zonals <= 18)\n');
    
    lgrav = input('? ');
    
    if (lgrav >= 0 && lgrav <= 18)
        
        break;
        
    end
    
end

while(1)
    
    fprintf('\nplease input the order of the gravity model (tesserals)\n');
    fprintf('(0 <= tesserals <= 18)\n');
    
    mgrav = input('? ');
    
    if (mgrav >= 0 && mgrav <= 18)
        
        break;
        
    end
    
end

% include solar perturbation?

while(1)
    
    fprintf('\nwould you like to include solar point-mass gravity (y = yes, n = no)\n');
    
    yn = lower(input('? ', 's'));
    
    if (yn == 'y' || yn == 'n')
        
        break;
        
    end
    
end

if (yn == 'y')
    
    isun = 1;
    
else
    
    isun = 0;
    
end

% include lunar perturbation?

while(1)
    
    fprintf('\nwould you like to include lunar point-mass gravity (y = yes, n = no)\n');
    
    yn = lower(input('? ', 's'));
    
    if (yn == 'y' || yn == 'n')
        
        break;
        
    end
    
end

if (yn == 'y')
    
    imoon = 1;
    
else
    
    imoon = 0;
    
end

% create and display graphics?

while (1)
    
    fprintf('\n\nwould you like to create and display graphics (y = yes, n = no)\n');
    
    yn = lower(input('? ', 's'));
    
    if (yn == 'y' || yn == 'n')
        
        break;
        
    end
    
end

if (yn == 'y')
    
    igraph = 1;
    
else
    
    igraph = 0;
    
end

if (igraph == 1)
    
    % request graphics step size
    
    while (1)
        
        fprintf('\n\nplease input the graphics step size (minutes)\n');
        
        dtstep = input('? ');
        
        if (dtstep > 0)
            
            break;
            
        end
        
    end
    
    dtstep = 60.0 * dtstep;
    
end

% request initial orbital elements

while (1)
    
    fprintf('\n\n orbital elements menu\n');
    
    fprintf('\n   <1> user input\n');
    
    fprintf('\n   <2> data file\n\n');
    
    slct = input('? ');
    
    if (slct == 1 || slct == 2)
        
        break;
        
    end
    
end

if (slct == 1)
    
    % interactive request
    
    fprintf('\n\ninitial orbital elements \n');
    
    oev1 = getoe([1;1;1;1;1;1]);
    
else
    
    % data file
    
    [filename, pathname] = uigetfile('*.in', 'please select an input data file');
    
    [fid, oev1] = readoe1(filename);
    
end

fprintf('\n\nplease wait, computing data ...\n\n');

% determine initial eci state vector

[ri, vi] = orb2eci(mu, oev1);

% load initial position and velocity vectors

for i = 1:1:3
    
    yi(i) = ri(i);
    
    yi(i + 3) = vi(i);
    
end

% compute initial julian date

jdate0 = julian(month, day, year) ...
    + uthr / 24 + utmin / 1440 + utsec / 86400;

% compute initial greenwich sidereal time

gst0 = gast1(jdate0);

if (igraph == 1)
    
    ti = -dtstep;
    
end

npts = 0;

if (igraph == 1)
    
    % create initial graphics data
    
    npts = npts + 1;
    
    t = 0;
    
    oev1 = eci2orb2 (mu, gst0, omega, t, ri, vi);
        
    xdata(npts) = t / 86400.0;
    
    for i = 1:1:11
        
        switch i
            
            case {1, 2}
                
                % semimajor axis and eccentricity
                
                ydata(i, npts) = oev1(i);
                
            case {3, 4, 5, 6}
                
                % inclination, argument of perigee, raan and true anomaly
                
                ydata(i, npts) = rtd * oev1(i);
                
            case 7
                
                % geodetic perigee altitude
                
                ydata(i, npts) = oev1(21);
                
            case 8
                
                % geodetic apogee altitude
                
                ydata(i, npts) = oev1(22);
                
        end
        
    end
    
end

while(1)
    
    % step size guess
    
    h = 30;
    
    if (igraph == 1)
        
        ti = ti + dtstep;
        
        tf = ti + dtstep;
        
    else
        
        ti = 0;
        
        tf = tsim;
        
    end
    
    % integrate from ti to tf
    
    yfinal = rkf78('ceqm1', neq, ti, tf, h, tetol, yi);
    
    if (igraph == 1)
        
        % create graphics data
        
        npts = npts + 1;
        
        % compute current state vector
        
        for i = 1:1:3
            
            rf(i) = yfinal(i);
            
            vf(i) = yfinal(i + 3);
            
        end
        
        % compute current orbital elements
        
        oev2 = eci2orb2(mu, gst0, omega, tf, rf, vf);
        
        % perigee altitude check
        
        alt = oev2(1) * (1.0 - oev2(2)) - req;
        
        if (alt <= 100.0)
            
            break;
            
        end
        
        xdata(npts) = tf / 86400.0;
        
        for i = 1:1:11
            
            switch i
                
                case {1, 2}
                    
                    % semimajor axis and eccentricity
                    
                    ydata(i, npts) = oev2(i);
                    
                case {3, 4, 5, 6}
                    
                    % inclination, argument of perigee, raan and true
                    % anomaly
                    
                    ydata(i, npts) = rtd * oev2(i);
                    
                case 7
                    
                    % geodetic perigee altitude
                    
                    ydata(i, npts) = oev2(21);
                    
                case 8
                    
                    % geodetic apogee altitude
                    
                    ydata(i, npts) = oev2(22);
                    
            end
            
        end
        
    end
    
    yi = yfinal;
    
    % check for end of simulation
    
    if (tf >= tsim)
        
        break;
        
    end
    
end

% compute final state vector and orbital elements

for i = 1:1:3
    
    rf(i) = yfinal(i);
    
    vf(i) = yfinal(i + 3);
    
end

oev2 = eci2orb1(mu, rf, vf);

%%%%%%%%%%%%%%%
% print results
%%%%%%%%%%%%%%%

[cdstr0, utstr0] = jd2str(jdate0);

jdatef = jdate0 + tf / 86400.0;

[cdstrf, utstrf] = jd2str(jdatef);

fprintf('\n program gto\n');

fprintf('\n < long-term evolution of geosynch transfer orbits >\n');

fprintf('\ninitial calendar date       ');

disp(cdstr0);

fprintf('initial UTC time      ');

disp(utstr0);

fprintf('\ninitial orbital elements and state vector\n');

oeprint1(mu, oev1);

svprint(ri, vi);

fprintf('\nfinal calendar date         ');

disp(cdstrf);

fprintf('final universal time        ');

disp(utstrf);

fprintf('\nfinal orbital elements and state vector\n');

oeprint1(mu, oev2);

svprint(rf, vf);

fprintf('\ndegree of gravity model    %2i', lgrav);

fprintf('\norder of gravity model     %2i \n', mgrav);

if (imoon == 1)
    
    fprintf('\nsimulation includes lunar point-mass gravity\n');
    
end

if (isun == 1)
    
    fprintf('\nsimulation includes solar point-mass gravity\n');
    
end

if (igraph == 1)
    
    % request item to plot
    
    while (1)
        
        while (1)
            
            fprintf('\n\nplease select the item to plot\n');
            
            fprintf('\n  <1> semimajor axis\n');
            
            fprintf('\n  <2> eccentricity\n');
            
            fprintf('\n  <3> orbital inclination\n');
            
            fprintf('\n  <4> argument of perigee\n');
            
            fprintf('\n  <5> right ascension of the ascending node\n');
            
            fprintf('\n  <6> true anomaly\n');
            
            fprintf('\n  <7> geodetic perigee altitude\n');
            
            fprintf('\n  <8> geodetic apogee altitude\n\n');
            
            oetype = input('? ');
            
            if (oetype >= 1 && oetype <= 8)
                
                break;
                
            end
            
        end
        
        % create and label plot
        
        plot(xdata, ydata(oetype, :));
        
        switch oetype
            
            case 1
                
                ylabel('semimajor axis (kilometers)', 'FontSize', 12);
                
            case 2
                
                ylabel('eccentricity', 'FontSize', 12);
                
            case 3
                
                ylabel('inclination (degrees)', 'FontSize', 12);
                
            case 4
                
                ylabel('argument of perigee (degrees)', 'FontSize', 12);
                
            case 5
                
                ylabel('RAAN (degrees)', 'FontSize', 12);
                
            case 6
                
                ylabel('true anomaly (degrees)', 'FontSize', 12');
                
            case 7
                
                ylabel('geodetic perigee altitude (kilometers)', 'FontSize', 12');
                
            case 8
                
                ylabel('geodetic apogee altitude (kilometers)', 'FontSize', 12);
                
        end
        
        title('Long Term Evolution of Geosynchronous Transfer Orbits', 'FontSize', 16);
        
        xlabel('mission elapsed time (days)', 'FontSize', 12);
        
        grid;
        
        zoom on;
        
        % create eps file with tiff preview
        
        print -depsc -tiff -r300 gto1.eps
        
        % create another plot?
        
        while (1)
            
            fprintf('\n\nwould you like to create another plot (y = yes, n = no)\n');
            
            yn = lower(input('? ', 's'));
            
            if (yn == 'y' || yn == 'n')
                
                break;
                
            end
            
        end
        
        if (yn == 'n')
            
            break;
            
        end
        
    end
end

fprintf('\n\n');
