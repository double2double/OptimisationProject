classdef Airplane < handle
    %(clouds,windX,windY,sun)
    %Detailed explanation goes here
    properties
        solarGain = []; %weather times sun intensity
        windX = [];
        windY = [];
        N = [];
        X = [];
        Y = [];
        sun = [];
        power = 0;
        xStart = 0;
        yStart = 0;
        xDestin = 0;
        yDestin = 0;
        xEnd = 1;
        yEnd = 1;
        electricEnergy = 1;
        V = zeros(3,1);
        % Scaling parameters
        solarWeight = 1;
        posWeight = 1;
        accelerationWeight = 100;
    end
    methods
        function obj = Airplane(clouds,windX,windY,X,Y,sun)
            obj.solarGain = clouds .* sun;
            obj.windX = windX;
            obj.windY = windY;
            obj.X = X;
            obj.Y = Y;
            [obj.N,~] = size(X);
        end 
        function SetStartPosition(obj,x,y)
            obj.xStart = x;
            obj.yStart = y;
        end
        function SetEndPosition(obj,x,y)
            obj.xEnd = x;
            obj.yEnd = y;
        end
        function [ V ] = weatherSpeedCost(obj, posVector )
            %% Debug cost function to check whats done so far.
            %
            
            startPos = posVector(1,1:2);
            endPos = posVector(end,1:2);
            VStartEnd = norm(startPos - [obj.xStart,obj.yStart]) + ...
                        norm(endPos - [obj.xEnd,obj.yEnd]);
            obj.V(1) = VStartEnd*1;
                    
            dx = 1/obj.N;
            VSunGain = 0;
            index = ( posVector(:,1) >1  &  posVector(:,1) <0);
            index = (index & (posVector(:,1) >1  &  posVector(:,1) <0 ));
            if (sum(index) > 1)
                V = Inf;
            else
                V = 0;
            end
            
            %Weather cost.
            for i = 1:1:length(posVector)
                %Get the position.
                xPos = posVector(i,1);
                yPos = posVector(i,2);    
                currentSolarGain = interp2(obj.X,obj.Y,obj.solarGain,xPos,yPos,'spline');
    
                VSunGain = VSunGain + currentSolarGain;
            end
            VSunGain = VSunGain*dx;
            obj.V(2) = - VSunGain*1;
            
            %minimize the acceleration.
            stepLength = zeros(obj.N-1,1);
            for i = 1:(obj.N-1)
                 stepLength(i) = norm(posVector(i,1:2) - posVector(i+1,1:2));   
            end
            acceleration = zeros(obj.N-3,1);
            for i = 1:(obj.N-3)
                %evalute central differences to find the second derivative:
                acceleration(i) = (stepLength(i) - 2*stepLength(i+1) + stepLength(i+2))/dx^2;
            end
            %acceleration = [0 acceleration 0];
            %add acceraltion cost.
            index = (acceleration > 0);
            posAcceleration = acceleration(index);
            Vacc = posAcceleration'*posAcceleration; %* self.mass;
            obj.V(3) = Vacc*0.1;
            
            V = V+sum(obj.V)

        end

        function plot(obj,path)
            figure()
            surf(obj.X,obj.Y,(obj.solarGain))
            hold on
            hig = 0.*path(:,1)+3;
            plot3(path(:,1),path(:,2),hig,'LineWidth', 2,'Color','r');
            view([0,0,90])
        end
        function value = getSun(obj, x, y)
            % A method to return a function object 
            value = interp2(obj.X,obj.Y,obj.clouds.*obj.sun,x,y,'cubic');
        end
    end
   
    
end

