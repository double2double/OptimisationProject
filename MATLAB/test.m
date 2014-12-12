%% A first test
close all
startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
m = 30;
time = 12;
date = 180;


[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( 2,5,m );
[ intensity ] = sunGrid( m,time,startLat,startLong,endLat,endLong );
plane = Airplane(Vcloud,VwindX,VwindY,X,Y,intensity);
plane.SetStartPosition(0.1,0.5);
plane.SetEndPosition(0.9,0.5);

% Create an initial guess for the path. 
x = linspace(0.1,0.9,m);
t = linspace(0,1,m);
y = sin(pi*x)+ 0.5;

path = [x;y;t]';


% Creating the inequality matrix for the time monoticity.
%           A*x < b
T = eye(m);
T(m,m) = -1;
for i=1:m-1
    T(i,i+1) = -1;
end
A = zeros(3*m);
A(2*m+1:end,2*m+1:end) = T;
b = zeros(m*3,1);

% Creating the equality costrain to keep the start time at 0
%           Aeq*x = beq
Aeq = zeros(3*m);
Aeq(2*m+1,2*m+1) = 1;
beq = zeros(m*3,1);

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

[opt ,V] = fmincon(@plane.weatherSpeedCost, path, A,b,Aeq,beq,qb,ub);

plane.plot(opt);
hold off

opt

















