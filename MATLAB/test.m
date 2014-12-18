%% A first test
close all
clear all
startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
m = 100;
time = 12;
date = 180;


[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( 2,4,m );
%[ ~,VwindX,VwindY,Xw,Yw ] = Static_Weather( 2,4,20 );
[ intensity ] = sunGrid( m,time,startLat,startLong,endLat,endLong );
plane = Airplane(Vcloud,VwindX,VwindY,X,Y,intensity);
plane.SetStartPosition(0.1,0.5);
plane.SetEndPosition(0.9,0.5);

% Create an initial guess for the path. 
x = linspace(0.1,0.9,m);
t = ones(1,m);
y = sin(pi*x).*0+ 0.5;

path = [x;y;t]';

% Uncomment this to get a good path for seed 2,4,30 == verry nice result
load('opt')
%path = opt;

% Creating the inequality matrix for the time monoticity.
%           A*x < b
A = -eye(m*3);
b = zeros(m*3,1);

% Creating the equality costrain to keep the start time at 0
%           Aeq*x = beq
Aeq = zeros(3*m);
Aeq(2*m+1,2*m+1:end) = 1;
beq = zeros(m*3,1);
beq(2*m+1) = m;

% Creating the equality costrain to keep the start time at 0
%           Aeq*x = beq
qb = zeros(m,3);
qb(1,1:2) = [0.1 0.5];
qb(end,1:2) = [0.9 0.5];
qb(1,3) = -1;
ub = ones(m,3);
ub(1,1:2) = [0.1 0.5];
ub(end,1:2) = [0.9 0.5];
ub(:,3) = 2;
%%
% Reminder: path is handled as a vector for the inequality constrains.

[opt ,V] = fmincon(@plane.energyEnd, path,A,b,Aeq,beq,qb,ub);

%plane.plotFancy(opt);

%% Plotting stuff


figure('position',[1000 1000 900 600]);
contourf(X,Y,(Vcloud.*intensity),20,'ShowText','off')
colorbar('YTickLabel',...
    {'Cloudy','','','','Sunny'})
title('Simulated cloud and wind data')
xlabel('X')
ylabel('Y')
hold on
quiver3(Xw,Yw,Yw.*0+3,VwindX,VwindY,Yw.*0,'k');
view([0,0,90])
axis([0 1 0 1 0 3])
hold off
exportfig('plots/RandomWeather.eps')




%% 
surf(peaks(30))
colorbar('YTickLabel',...
    {'Freezing','Cold','Cool','Neutral',...
     'Warm','Hot','Burning','Nuclear'})
















