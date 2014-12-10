%% A first test

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
plane.SetStartPosition(0.5,0.1);
plane.SetEndPosition(0.5,0.9);

% Create an initial guess for the path.

y = linspace(0,1,20);
x = linspace(0.5,0.5,20);
t = linspace(0,1,20);

path = [x;y;t];

plane.getSun(0,1/pi)




