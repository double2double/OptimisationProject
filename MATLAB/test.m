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
x = sin(y*pi);
t = linspace(0,1,20);

path = [x;y;t];


plane.posWeight = 100;
plane.accelerationWeight = 0.1;


[opt ,V] = fminunc(@plane.weatherSpeedCost, path', optimset('LargeScale','off'));

figure(1)
plane.plot(opt');
figure(2)
plane.plot(path);

