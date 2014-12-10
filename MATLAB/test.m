%% A first test
close all
startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
m = 30;
time = 12;
date = 180;


[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( 2,10,m );
[ intensity ] = sunGrid( m,time,startLat,startLong,endLat,endLong );
plane = Airplane(Vcloud,VwindX,VwindY,X,Y,intensity);
plane.SetStartPosition(0.1,0.5);
plane.SetEndPosition(0.9,0.5);

% Create an initial guess for the path.

 
x = linspace(0.1,0.9,m);
t = linspace(0,1,m);
y = x.*0 + 0.5;

path = [x;y]';


plane.posWeight = 100;
plane.accelerationWeight = 0.001;

qb = zeros(m,3);
qb(1,1:2) = [0.1 0.5];
qb(end,1:2) = [0.9 0.5];

ub = ones(m,3);
ub(1,1:2) = [0.1 0.5];
ub(end,1:2) = [0.9 0.5];

[opt ,V] = fmincon(@plane.weatherSpeedCost, path, [],[],[],[],qb,ub);

plane.plot(opt);
hold off
plane.plot(path);

