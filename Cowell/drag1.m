function adrag = drag1(sv)
   
% acceleration due to atmospheric drag

% us standard 1976 atmosphere model

% input

%  sv = ECI state vector (km and km/sec)

% output

%  adrag = ECI drag acceleration vector
%          (kilometers/second/second)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global omega bcoeff
global jdate
global jdset

adrag = zeros(3, 1);

% compute geodetic coordinates

rmag = sqrt(sv(1) * sv(1) + sv(2) * sv(2) + sv(3) * sv(3));

dec = asin(sv(3) / rmag);

[alt, xlat] = geodet1(rmag, dec);

% calculate atmospheric density (kg/km^3)

rho = atmos76(alt);

% velocity vector of atmosphere relative to spacecraft

v3(1) = sv(4) + omega * sv(2);
v3(2) = sv(5) - omega * sv(1);
v3(3) = sv(6);

vrel = norm(v3);

% acceleration vector

rho = compRho(jdate,sv);

adrag = -0.5 * rho * 1e9 * bcoeff * vrel * v3;
