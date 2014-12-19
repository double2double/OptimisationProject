%% This script runs the optimisation project.
close all
clear all
addpath('functions')
% Setting up some parameters
m = 10;                         % number of steps in the path (30 gives good solution)
k = 2;                          % Seed for the clouds
l = 4;                          % Complexity for clouds
% Setting up constants for the sun model
startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
time = 12;
date = 180;

% Creating weather
[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( 2,4,m );
[ intensity ] = sunGrid( m,time,startLat,startLong,endLat,endLong );

% Initialising the plane with the weather and setting start end end.
plane = Airplane(Vcloud,VwindX,VwindY,X,Y,intensity);
plane.SetStartPosition(0.1,0.5);
plane.SetEndPosition(0.9,0.5);

% Create an initial guess for the path (Just a straight line)
x = linspace(0.1,0.9,m);
t = ones(1,m);
y = sin(pi*x).*0+ 0.5;
path = [x;y;t]';


% Creating the inequality matrix for the time monoticity, i.e. make shure the
% dts are always greater then zero.
%           A*x < b
A = -eye(m*3);
b = zeros(m*3,1);

% Create a constraint to make the sum of the different time steps equal to
% the total time.
%           Aeq*x = beq
Aeq = zeros(3*m);
Aeq(2*m+1,2*m+1:end) = 1;
beq = zeros(m*3,1);
beq(2*m+1) = 30;

% Creating the equality costrain to keep the start time at 0 and prevent
% the optimizer from leaving the grid.
qb = zeros(m,3);
qb(1,1:2) = [0.1 0.5];
qb(end,1:2) = [0.9 0.5];
qb(1,3) = 0;
ub = ones(m,3);
ub(1,1:2) = [0.1 0.5];
ub(end,1:2) = [0.9 0.5];
ub(:,3) = 2;
%% Calculating the optimal path
[opt ,V] = fmincon(@plane.energyEnd, path,A,b,Aeq,beq,qb,ub);

%% plotting the path
plane.plotFancy(opt);























