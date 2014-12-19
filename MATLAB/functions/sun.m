function [intensity] = sun(longitude,latitude,localtime,localdate)
        %This function calculates the sun-intensity based on local time
        %and position. Input is position in logitude and latitude in 
        %degrees. Its is assumed GMT is used with zero degrees in green-
        %wich. Localdate is in days since the beginning of the year.
        %Localtime is the time of the day on a 24 hour clock.
        
%Find the local standart time zone, the world is divided into 24 time
%zones with 360 degree latidue that means rougle a new time zone every
%15 degrees.
timeZone = double(floor(longitude/15));
timeZone = 1;
%With the newly computed time zone it's possible to compute the meridian,
%that belongs to this specific time zone. It's colled the Local Standard Time Meridian
localStandartTimeMeridian = 15 * timeZone;

%Use the equation of time (EoT) to correct for the eart's axial tilt and
%the eccentricity:
B = 360/365 * (localdate - 81);
equationOfTime = 9.87 * sin(2 * B *pi/180) - 7.53 * cos(B*pi/180) - 1.5 * sin(B*pi/180); 

%Find the time correction factor. To account for variations within the
%curren time zone.
timeCorrection = 4 * (longitude-localStandartTimeMeridian) + equationOfTime;

%With this newly found correction term we can compute the solar time:
localSolarTime = localtime + timeCorrection/60;

%With the now corrected time its possible to find the hour Angle of the
%sun:
%with uncool linear polinomial to deal adjust for latitude. Better Ideas?
hourAngle = 15 * (localSolarTime - 12) * (-0.006197 * latitude +  1.024);

%Now we are ready to find the suns position:
declination = 23.45 * sin(360/365 * (localdate -81)*pi/180); %declination = delta.

%convert to radians:
decRad = declination*pi/180;
latRad = latitude*pi/180;

%sunElevation = asin(-sin(decRad)*sin(latRad) + cos(decRad) * cos(latRad) * cos(hourAngle*pi/180)
%sunAzimuth = acos((sin(decRad) * cos(latRad) - cos(decRad) *sin(latRad) * cos(hourAngle*pi/180))/cos(elevation*pi/180))

%now we're ready to find sun rise and sunset - times.
x = (-sin(latRad) * sin(decRad)) / (cos(latRad) * cos(decRad));
H = (acos(x) * 1 / 15.0)*180/pi;
sunrise = 12.0 - H;
sunset = 12.0 + H;	

%The the yield of our solar panles depends now on the air mass that the
%light has to go trough before it reaches the panels.


if localtime <= sunrise
    intensity = 0;
elseif localtime >= sunset
    intensity = 0;
else
    airMass = 1/cos(hourAngle*pi/180);      %TODO:Add the flight hight.
    intensity = 1.353 * 0.7^(abs(airMass)^0.678);
end
if latitude ~= 0
    intensity = intensity/(latitude/15);
end


end
    
