function oneTLE(NORAD_ID)



path = ['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\Orbital_Elements\1U\' num2str(NORAD_ID) '_OE.txt'];
test   = dlmread(path);
aa = test(:,3);
plot(aa)
grid on