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
            obj.windX = 0.04*windX;
            obj.windY = 0.04*windY;
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
        function [ V ] = energyEnd(obj, traject )
            energy = obj.getEnergy(traject);
            V = -energy(end)
        end
        function Energy = getEnergy(obj,traject)
            Vaccel = -0.03;
            Vsun = 1;
            Vdrag = -100;
            % Calculating the relative speed
            speed = obj.relativespeed(traject);
            % Calculating the acceleration cost
            acceleration = obj.acceleration(traject);
            posAcceleration = acceleration.*(acceleration > 0);
            posAcceleration = [posAcceleration;0;0];
            Accel = posAcceleration'*posAcceleration;
            %Weather cost.
            Sun = obj.sunCost(traject);
            % Calculating Energy per step
            Energy = zeros(obj.N,1);
            for i = 2:obj.N
                Energy(i) = Energy(i-1)+ Sun(i-1).*Vsun ...
                                       + speed(i-1)^2*Vdrag ...
                                       + posAcceleration(i-1)^2*Vaccel;
            end
        end
        % Some aid functions.
        function weather = sunCost(obj,traject)
            dt = traject(1:end-1,3);
            stepLength = obj.stepLength(traject);
            weather = zeros(obj.N-1,1);
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
                weather(i) = tmp*dt(i);
            end 
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
        function Vrel = relativespeed(obj,traject)
            dt = traject(1:end-1,3);
            Vrel = zeros(obj.N-1,1);
            for i = 1:(obj.N-1)
                 vx = (traject(i+1,1) - traject(i,1))./dt(i);
                 vy = (traject(i+1,2) - traject(i,2))./dt(i);
                 x = (traject(i,1) - traject(i+1,1))/2;
                 y = (traject(i,2) - traject(i+1,2))/2;
                 vwindx = interp2(obj.X,obj.Y,obj.windX,x,y,'spline');
                 vwindy = interp2(obj.X,obj.Y,obj.windY,x,y,'spline');
                 vrelx = (vx - vwindx);
                 vrely = (vy - vwindy);
                 Vrel(i) = norm([vrelx vrely]);
            end
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
            quiver3(obj.X,obj.Y,obj.Y.*0+3,obj.windX,obj.windY,obj.Y.*0,'k');
            plot3(traject(:,1),traject(:,2),hig,'LineWidth', 5,'Color','k');
            view([0,0,90])
            axis([0 1 0 1 0 3])
            hold off
        end
        function plotFancy(obj,traject)
            figure('position',[1000 1000 900 600]);
            %subplot(2,3,1);
            % Plotting the traject
            surf(obj.X,obj.Y,(obj.solarGain))
            hold on
            hig = 0.*traject(:,1)+3;
            quiver3(obj.X,obj.Y,obj.Y.*0+3,obj.windX,obj.windY,obj.Y.*0,'k');
            plot3(traject(:,1),traject(:,2),hig,'LineWidth', 5,'Color','k');
            view([0,0,90])
            axis([0 1 0 1 0 3])
            hold off
            exportfig('plots/path.eps')
            figure('position',[1000 1000 900 600]); %subplot(2,3,2);
            % Plotting the speed/ relative speed
            speed = obj.speed(traject);
            relspeed = obj.relativespeed(traject);
            x = linspace(0,1,obj.N-1);
            plot(x,speed);
            hold on
            box on
            plot(x,relspeed,'r');
            %legend('speed','relative speed');
            ylabel('speed')
            hold off
            exportfig('plots/speed.eps')
            figure('position',[1000 1000 900 600]); %subplot(2,3,3);
            % Plotting the solar gain
            sunCost = obj.sunCost(traject);
            x = linspace(0,1,obj.N-1);
            plot(x,-sunCost);
            ylabel('Sun gain')
            box on
            exportfig('plots/sun.eps')
            figure('position',[1000 1000 900 600]); %subplot(2,3,4);
            % Plotting the accel
            accel = obj.acceleration(traject);
            %legend('acceleration')
            x = linspace(0,1,obj.N-3);
            plot(x,accel);
            ylabel('Acceleration')
            box on
            exportfig('plots/acc.eps')
            figure('position',[1000 1000 900 600]); %subplot(2,3,5)
            % Plotting the energy
            energy = obj.getEnergy(traject);
            x = linspace(0,1,obj.N);
            plot(x,energy);
            ylabel('Enegy')
            box on
            exportfig('plots/Energy.eps')
            figure('position',[1000 1000 900 600]); %subplot(2,3,6)
            % Plotting the energy
            energy = obj.getEnergy(traject);
            x = linspace(0,1,obj.N);
            de = zeros(obj.N-1,1);
            for i=1:obj.N-1
                de(i) = (energy(i+1)-energy(i))/(x(i+1)-x(i));
            end
            x = linspace(0,1,obj.N-1);
            plot(x,de);
            ylabel('Enegy per step')
            box on
            exportfig('plots/De.eps')
            
        end
        function value = getSun(obj, x, y)
            % A method to return a function object 
            value = interp2(obj.X,obj.Y,obj.clouds.*obj.sun,x,y,'cubic');
        end
    end
   
    
end

