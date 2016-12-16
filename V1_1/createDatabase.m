function Database = createDatabase(NORAD_ID)

downloadTLEhistory(NORAD_ID);
TLE2OEconversion(NORAD_ID);
combineTLE();

cd('D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\');

Database = TLEselection(NORAD_ID);  

%(1) semi-major axis
%(2) eccentriciy
%(3) inclination
%(4) RAAN
%(5) Argument of Perigee
%(6) Mean Anomaly 

end