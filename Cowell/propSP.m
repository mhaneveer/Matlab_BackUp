% cowell.m       December 24, 2012

% orbital motion of Earth satellites
% using Cowell's method and equations
% of motion in rectangular coordinates

% includes perturbations due to:

%   non-spherical earth gravity
%   aerodynamic drag (us 76 model)
%   solar radiation pressure
%   sun and moon point-mass gravity

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xdata, ydata] = propSP(jd,ndays,tstep,OE,eci)

tic

global dtr rtd atr

global flat req mu smu mmu aunit omega

global j2 lgrav mgrav

global jdate0 gst0 isun imoon idrag isrp

global rkcoef ccoef scoef ad76 bcoeff csrp0


% astrodynamic and utility constants

om_constants;

% radius of the sun (kilometers)

dsun = 696000;             

% radius of the moon (kilometers)

dmoon = 1738;              

% solar constant

ps = 0.00456; 

atr = dtr / 3600;

% initialize rkf78 integrator

rkcoef = 1;

% define number of differential equations

neq = 6;

% read gravity model coefficients

gmfile = 'egm96.dat';

[ccoef, scoef] = readegm(gmfile);

% extract j2 coefficient

j2 = -ccoef(3, 1);

if (strcmp(gmfile, 'egm96.dat'))
    
    % egm96 constants

    mu = 398600.4415;
    
    req = 6378.1363;
    
    omega = 7.292115e-5;
    
end

% begin simulation


fprintf('\n                Program Cowell\n');

fprintf('\n  < Earth orbital motion - Cowell''s method >\n');

[year,month,day,uthr,utmin,utsec] = julian2greg(jd');

tsim = 86400.0 * ndays;

tetol = 1.0e-9;
%tetol = 12;

isun = 1;
imoon = 1;
idrag = 1;
isrp = 1;

igraph = 1;
dtstep = 60;        %in minutes

slct = 1;

%global a e incl raan lonper m           %IN RADIANS!!

%oev1 = getoe([1;1;1;1;1;1]);

oev1 = OE;
    

%fprintf('\naerodynamic drag inputs \n');

[fid, ad76] = read76;

cd = 2.2;
areadrag = 0.14 * 0.14;
scmass = 0.7;

bcoeff = 1.0e-6 * areadrag * cd /scmass;

reflect = 0.2;
areasrp = 0.1 * 0.1 ;

csrp0 = 0.000001 * reflect * ps * aunit^2 * areasrp / scmass;

fprintf('\n\nplease wait, computing data ...\n\n');

% determine initial eci state vector

%[ri, vi] = orb2eci(mu, oev1);
ri = eci(:,1);
vi = eci(:,2);

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

    oev = eci2orb2 (mu, gst0, omega, t, ri, vi);

    xdata(npts) = t / 86400.0;

    for i = 1:1:11
        
        switch i
            
            case {1, 2}
                
                ydata(i, npts) = oev(i);
                
            case {3, 4, 5, 6}
                
                ydata(i, npts) = rtd * oev(i);
                
            case 7
                
                ydata(i, npts) = rtd * oev(21);
                
            case 8
                
                ydata(i, npts) = oev(22);
                
            case 9
                
                ydata(i, npts) = oev(16);
                
            case 10
                
                ydata(i, npts) = rtd * oev(15);
                
            case 11
                
                ydata(i, npts) = rtd * oev(14);
                
        end
        
    end
    
end

while(1)
    
    % step size guess

    h = 1;

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

        % altitude check

        alt = oev2(1) * (1.0 - oev2(2)) - req;

        if (alt <= 90.0)
            
            break;
            
        end

        xdata(npts) = tf / 86400.0;

        for i = 1:1:11
            
            switch i
                
                case {1, 2}
                    
                    ydata(i, npts) = oev2(i);
                    
                case {3, 4, 5, 6}
                    
                    ydata(i, npts) = rtd * oev2(i);
                    
                case 7
                    
                    ydata(i, npts) = rtd * oev2(21);
                    
                case 8
                    
                    ydata(i, npts) = oev2(22);
                    
                case 9
                    
                    ydata(i, npts) = oev2(16);
                    
                case 10
                    
                    ydata(i, npts) = rtd * oev2(15);
                    
                case 11
                    
                    ydata(i, npts) = rtd * oev2(14);
                    
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

% print results

[cdstr0, utstr0] = jd2str(jdate0);

jdatef = jdate0 + tf / 86400;

[cdstrf, utstrf] = jd2str(jdatef);

fprintf('\n                     program cowell\n');

fprintf('\n    < Earth orbital motion - Cowell''s method >\n');

fprintf('\ninitial calendar date       ');

disp(cdstr0);

fprintf('initial universal time      ');

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

if (isun == 1)
    
    fprintf('\nsimulation includes solar perturbations');
    
end

if (imoon == 1)
    
    fprintf('\nsimulation includes lunar perturbations');
    
end

if (idrag == 1)
    
    fprintf('\nsimulation includes drag perturbations');
    
end

if (isrp == 1)
    
    fprintf('\nsimulation includes srp perturbations');
    
end

igraph = 0;

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

            fprintf('\n  <8> geodetic apogee altitude\n');

            fprintf('\n  <9> geodetic altitude\n');

            fprintf('\n  <10> east longitude\n');

            fprintf('\n  <11> geodetic latitude\n\n');

            oetype = input('? ');

            if (oetype >= 1 && oetype <= 11)
                
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
                ylabel('perigee altitude (kilometers)', 'FontSize', 12');
            case 8
                ylabel('apogee altitude (kilometers)', 'FontSize', 12);
            case 9
                ylabel('altitude (kilometers)', 'FontSize', 12);
            case 10
                ylabel('east longitude (degrees)', 'FontSize', 12);
            case 11
                ylabel('geodetic latitude (degrees)', 'FontSize', 12);
        end

        title('Long Term Orbit Evolution - Cowell''s Method', 'FontSize', 16);

        xlabel('simulation time (days)', 'FontSize', 12);

        grid;

        zoom on;

        % create eps file with tiff preview

        print -depsc -tiff -r300 cowell1.eps

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

