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
        Vend = Inf;
        bestPath = [];
    end
    methods
        function obj = Airplane(clouds,windX,windY,X,Y,sun)
            obj.solarGain = clouds.*sun ;
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
        function [ V ] = weatherSpeedCost(obj, traject )
            % Debug cost function to check whats done so far.
            % setting up some parameters
            Vaccel = 0.01;
            Vsun = -3;
            Vdrag = 100;
            % Calculating the traject lenght.
            stepLength = obj.stepLength(traject);
            dt = traject(1:end-1,3);
            speed = stepLength./dt;
            
            % Calculating the acceleration cost
            acceleration = obj.acceleration(traject);
            posAcceleration = acceleration((acceleration > 0));
            Accel = posAcceleration'*posAcceleration;
            
            %Weather cost.
            Sun = obj.WeaterCost(traject);
            % Calculating the V
            Sun = Sun .* Vsun;  
            Drag = speed'*speed*Vdrag;
            Accel = Accel*Vaccel;
            obj.V(1) = Accel;
            obj.V(2) = Sun;
            obj.V(3) = Drag;
            V = obj.power+sum(obj.V);
            if (V<obj.Vend)
                obj.bestPath = traject;
            end
            obj.V

        end
        % Some aid functions.
        function weather = WeaterCost(obj,traject)
            Sun = 0;
            dt = traject(1:end-1,3);
            stepLength = obj.stepLength(traject);
            for i = 1:1:(obj.N-1)
                %Get the position.
                xPos = traject(i,1);
                yPos = traject(i,2);
                NextxPos = traject(i+1,1);
                NextyPos = traject(i+1,2);
                n = ceil(stepLength(i)*10)+1;
                points = [linspace(xPos,NextxPos,n+1);linspace(yPos,NextyPos,n+1)];
                tmp = 0;
                for j=1:n
                    x = points(1,j);
                    y = points(2,j);
                    currentSolarGain = interp2(obj.X,obj.Y,obj.solarGain,x,y,'spline');
                    tmp = tmp+currentSolarGain;
                end
                tmp = tmp/n;        % The average sun at the path
                Sun = Sun+ tmp*dt(i);
            end 
            weather = Sun;
        end
        
        
        function stepLen = stepLength(obj,traject)
            stepLen = zeros(obj.N-1,1);
            for i = 1:(obj.N-1)
                 stepLen(i) = norm(traject(i,1:2) - traject(i+1,1:2));
            end
            
        end
        function speed = speed(obj,traject)
            dt = traject(1:end-1,3);
            stepLen = obj.stepLength(traject);
            speed = stepLen./dt;
        end
        function accel = acceleration(obj,traject)
            accel = zeros(obj.N-3,1);
            stepLength = obj.stepLength(traject);
            dt = traject(1:end-1,3);
            for i = 1:(obj.N-3)
                %evalute central differences to find the second derivative:
                accel(i) = (stepLength(i) - 2*stepLength(i+1) + stepLength(i+2))/(dt(i)^2);
            end
        end
        function plot(obj,traject)
            figure()
            surf(obj.X,obj.Y,(obj.solarGain))
            hold on
            hig = 0.*traject(:,1)+3;
            plot3(traject(:,1),traject(:,2),hig,'LineWidth', 2,'Color','r');
            view([0,0,90])
        end
        function value = getSun(obj, x, y)
            % A method to return a function object 
            value = interp2(obj.X,obj.Y,obj.clouds.*obj.sun,x,y,'cubic');
        end
    end
   
    
end

