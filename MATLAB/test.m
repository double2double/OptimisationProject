%% A first test
close all
startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
m = 20;
time = 12;
date = 180;


[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( 1,2,m );
[ intensity ] = sunGrid( m,time,startLat,startLong,endLat,endLong );
plane = Airplane(Vcloud,VwindX,VwindY,X,Y,intensity);
plane.SetStartPosition(0.1,0.5);
plane.SetEndPosition(0.9,0.5);

% Create an initial guess for the path.

 
x = linspace(0.1,0.9,20);
t = linspace(0,1,20);
y = sin(t*2*pi)/4 + 0.5;

path = [x;y;t]';


plane.posWeight = 100;
plane.accelerationWeight = 0.001;


[opt ,V] = fminunc(@plane.weatherSpeedCost, path, optimset('LargeScale','off'));

plane.plot(opt);
hold off
plane.plot(path);

