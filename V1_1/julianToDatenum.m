function dateNum = julianToDatenum(julian)
% julianToDatenum -- Convert Julian Day to Matlab datenum.
%  julianToDatenum(dateNum) converts Julian day with days since
%   1950-01-01 00:00:00 to its equivalent dateNum (Matlab
%   datenum)  
% $Id$


if nargin < 1, help(mfilename), return, end

origin = datenum(1950,0, 0);

result = origin + julian;

if nargout > 0
	dateNum = result;
else
	disp(result)
end
