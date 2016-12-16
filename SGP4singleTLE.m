function [pGP,aGP,eccGP,inclGP,omegaGP,argpGP,nuGP,mGP,arglatGP,truelonGP,lonperGP] = SGP4singleTLE(satrec,tsince)

global mu whichconst
tic
for i = 1:length(tsince)
[satrec, r(i,:), v(i,:)] = sgp4(satrec,tsince(i));
[pGP(i),aGP(i),eccGP(i),inclGP(i),omegaGP(i),argpGP(i),nuGP(i),mGP(i),arglatGP(i) ...
    ,truelonGP(i),lonperGP(i)] = rv2coe (r(i,:),v(i,:),mu);
end

fprintf('\n  < SGP4 Propagation Completed  >\n');
toc
end
