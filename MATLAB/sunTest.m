clear all;
latitude = 0     %=> 1
%latitude = 20;    %=> 0.9
%latitude = 30;   %=> 0.85
%latitude = 40;   %=> 0.8
%latitude = 50;   %=> 0.75
%latitude = 60;    %=> 0.65
%latitude = 65;   %=> 5.75
longitude = 0;
localdate = 180;

localtime = 1:0.1:24;

for i = 1:1:length(localtime)  
   [H,hourAngle(i),intensity(i)] = sun(longitude,latitude,localtime(i),localdate);
end

plot(localtime,intensity)
%hold on;
%plot(localtime,cos(hourAngle*pi/180))

x = [0, 20, 30, 40, 50, 60, 65]
fx = [1, 0.9, 0.85, 0.8, 0.75, 0.65, 0.575]