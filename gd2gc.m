%---------------------------------------------------------------------------
%
%  gd2gc
%
%  this function converts from geodetic to geocentric latitude for positions
%  on the surface of the earth.  notice that (1-f) squared = 1-esqrd.
%
%  input:
%    latgd       - geodetic latitude       -pi to pi rad
%
%  output:
%    latgc       - geocentric latitude     -pi to pi rad
%
%  reference:
%    vallado       2001, 146, eq 3-11
%
%---------------------------------------------------------------------------
function [latgc] = gd2gc ( latgd )

eesqrd = 0.006694385000;     % eccentricity of earth sqrd

% -------------------------  implementation   -----------------
latgc= atan( (1.0  - eesqrd)*tan(latgd) );
