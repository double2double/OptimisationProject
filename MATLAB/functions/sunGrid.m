function [ intensity ] = sunGrid( m,time,startLat,startLong,endLat,endLong )
%This funciton returns a grid with sun intensity values depending on time
%in hours. The number of days since the beginning of the year date.
%the number of grid points m and the start and end position.

%munich
%48°N, 11°E
%brussels
% 50°N, 4°E
% startLat = 50;
% endLat = 48;
% startLong = 0;
% endLong = 10;
% m = 20;
% time = 12;
date = 180;

stepNumber = m;
stepSizeLat = ((endLat - startLat)/m);
stepSizeLong = ((endLong - startLong)/m);
intensity = zeros(m);


for i = 1:1:m
    for j = 1:1:m
        
       lat =  startLat + i*stepSizeLat;
       long = startLong + j*stepSizeLong;
       intensity(i,j) = sun(long,lat,time,date); 
        
    end
end

% x = 0:1/m:1;
% y = 0:1/m:1;
% 
% x = x(1:20);
% y = y(1:20);
% surf(x,y,intensity);