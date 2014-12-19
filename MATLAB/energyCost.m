function [ V ] = energyCost( posVector,plane )
%This function computes the energy collected on a given path.
%
 dx = 1/plane.N;
 currentSolarGain = 0;
 VSunGain = 0;
 for i = 1:1:length(posVector)
        %Get the position.
        xPos = posVector(i,1);
        yPos = posVector(i,2);    
        currentSolarGain = interp2(plane.X,plane.Y, ...
        plane.solarGain,xPos,yPos,'spline');
    
        VSunGain = VSunGain + currentSolarGain;
 end
 VSunGain = VSunGain*dx;
 V = - VSunGain*plane.solarWeight;
end

