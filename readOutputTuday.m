close all
clear all
clc

path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\TUDAT\tudatBundle\tudatApplications\Application2\TemplateApplication\asterixPropagationHistory_4.dat';

A = dlmread(path);
mu = 3.986004418e5;
earthradius = 6371;

r = [A(:,2) A(:,3) A(:,4)]' / 1e3;
v = [A(:,5) A(:,6) A(:,7)]' / 1e3;

[a,eMag,i,O,o,nu,truLon,argLat,lonPer,p] = rv2orb(r,v,mu);

alt = a - earthradius;
plot(alt)