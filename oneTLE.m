function oneTLE(NORAD_ID)



path = ['D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\CubeSat_TLE\Orbital_Elements_and_RV\' num2str(NORAD_ID) '_OE.txt'];

%path = 'D:\Documents\TU_Delft\MSc\Thesis\02_Program\Data\Test\60_OE.txt'
test   = dlmread(path);
aa = test(:,3);
plot(aa)
grid on