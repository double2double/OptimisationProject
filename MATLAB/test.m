%% A first test
close all
clear all
startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
m = 30;
time = 12;
date = 180;

k = 20;
l = 10;
[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( k,l,m );
%[ ~,VwindX2,VwindY2,Xw,Yw ] = Static_Weather( k,l,20 );
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
path = opt;

% Creating the inequality matrix for the time monoticity.
%           A*x < b
A = -eye(m*3);
b = zeros(m*3,1);

% Creating the equality costrain to keep the start time at 0
%           Aeq*x = beq
Aeq = zeros(3*m);
Aeq(2*m+1,2*m+1:end) = 1;
beq = zeros(m*3,1);
beq(2*m+1) = 30;

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

plane.plotFancy(opt);
save('opt','opt')
%% Plotting stuff

[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( k,l,100 );
[ intensity ] = sunGrid( 100,time,startLat,startLong,endLat,endLong );
[ ~,VwindX2,VwindY2,Xw,Yw ] = Static_Weather( k,l,20 );


traject = path;
figure('position',[1000 1000 900 600]);
contourf(X,Y,(Vcloud.*intensity),20,'ShowText','off')
handleToColorBar = colorbar('westoutside');

a = get(handleToColorBar,'position');
a(3) = a(3)/2;
a(1) = a(1) -0.09;
set(handleToColorBar,'position', a);
set(handleToColorBar,'YTickLabel', []);
hYLabel = ylabel(handleToColorBar, 'Cloudy                                     Sunny');
set(hYLabel,'Rotation',90);
%colorbar('southoutside','YTickLabel',...
%    {'Cloudy','','','','Sunny'})
title('Simulated cloud and wind data')
xlabel('X')
ylabel('Y')
hold on
hig = 0.*traject(:,1)+3;
plot3(traject(:,1),traject(:,2),hig,'--k','LineWidth', 2);
traject = opt;
plot3(traject(:,1),traject(:,2),hig,'-k','LineWidth', 2);
quiver3(Xw,Yw,Yw.*0+3,VwindX2,VwindY2,Yw.*0,'k');
view([0,0,90])
axis([0 1 0 1 0 3])
hold off
exportfig('plots/RandomWeather.eps')























