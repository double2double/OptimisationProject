%function [ V ] = airCost( posVector )
%The function integrates over the path in order to find good values for
%the sun.

%Guess an initial posVector.
posVector = zeros(20,2);
posVector(:,1) = 0:1/(20-1):1;
posVector(:,2) = 0.5;


startLat = 50;
endLat = 48;
startLong = 0;
endLong = 10;
m = 20;
time = 12;
seed = 1;
n = 2;


X = 0:1/(m-1):1; 
Y = 0:1/(m-1):1; 

intensity = sunGrid( m,time,startLat,startLong,endLat,endLong );
[ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather(seed, n ,m);

V = 0;
%Weather cost.
for i = 1:1:length(posVector)
    %Get the position.
    xPos = posVector(i,1);
    yPos = posVector(i,2);    
    currentVCloud = interp2(X,Y,Vcloud,xPos,yPos);
    
    V = V + currentVCloud;
end
disp(V)
%Keep the points together!
for i = 1:1:(length(posVector)-1)
   %V = V +  norm(
end




%Plot stuff.

subplot(1,3,1)
surf(X,Y,Vcloud);
title('Cloud density');
view(0,90)
hold on
subplot(1,3,2)
quiver(X,Y,VwindX,VwindY);
axis([0,1,0,1])
hold off
title('Wind direction');
subplot(1,3,3)
surf(X,Y,intensity)
view(0,90)


%end

