clear all;
latitude = 0     %=> 1
latitude = 20;    %=> 0.9
latitude = 30;   %=> 0.85
latitude = 40;   %=> 0.8
latitude = 50;   %=> 0.75
latitude = 60; %=> 0.65
%latitude = 90;

longitude = 0;
longitude = 5;
%longitude = 10;
%longitude = 30;
%longitude = 40;

localdate = 180;

localtime = 1:0.1:24;


for i = 1:1:length(localtime)  
    [intensity(i)] = sun(longitude,latitude,localtime(i),localdate);
end

plot(localtime,intensity)
hold on;
%plot(localtime,cos(hourAngle*pi/180))
