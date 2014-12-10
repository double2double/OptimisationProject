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
            % setting up some parameters
            stepLength = zeros(obj.N-1,1);
            speed = zeros(obj.N-1,1);
            acceleration = zeros(obj.N-3,1);
            T = 10;
            VSunGain = 0;
            Vsun = -1;
            Vaccel = 0.01;
            % Calculating the path lenght.
            for i = 1:(obj.N-1)
                 stepLength(i) = norm(posVector(i,1:2) - posVector(i+1,1:2));
            end
            len = sum(stepLength);
            dt = T/len;
            speed = stepLength./dt;
            % Calculating the acceleration
            for i = 1:(obj.N-3)
                %evalute central differences to find the second derivative:
                acceleration(i) = (speed(i) - 2*speed(i+1) + speed(i+2))/dt;
            end
            Vdrag = speed'*speed*200;
            index = (acceleration > 0);
            posAcceleration = acceleration(index);
            Vacc = posAcceleration'*posAcceleration;
            obj.V(1) = Vacc*Vaccel;
            %Weather cost.
            tmp = 0;
            for i = 1:1:(obj.N-1)
                %Get the position.
                xPos = posVector(i,1);
                yPos = posVector(i,2);
                NextxPos = posVector(i+1,1);
                NextyPos = posVector(i+1,2);
                n = ceil(stepLength(i)*5);
                dx = stepLength(i)/n;
                points = [linspace(xPos,NextxPos,n);linspace(yPos,NextyPos,n)];
                for j=1:n
                    x = points(1,j);
                    y = points(2,j);
                    currentSolarGain = interp2(obj.X,obj.Y,obj.solarGain,x,y,'spline');
                    tmp = tmp+currentSolarGain*dx;
                end
            end
            VSunGain = tmp .* Vsun;
            obj.V(2) = VSunGain;
            V = obj.power+sum(obj.V) +Vdrag

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

