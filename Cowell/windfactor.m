function [F] = windfactor(r,v,incl)

w = 7.2921159e-5;

rtot = sqrt(r(1).^2+r(2).^2+r(3).^2);
vtot = sqrt(v(1).^2+v(2).^2+v(3).^2);

F = (1 - (rtot * w / vtot) * cos(incl))^2;
end

