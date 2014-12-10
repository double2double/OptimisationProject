classdef Airplane
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    properties
        clouds = [];
        windX = [];
        windY = [];
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
    end
    methods
        function obj = Airplane(clouds,windX,windY,X,Y,sun)
            obj.clouds = clouds;
            obj.windX = windX;
            obj.windY = windY;
            obj.X = X;
            obj.Y = Y;
            obj.sun = sun;
        end 
        function SetStartPosition(obj,x,y)
            obj.xStart = x;
            obj.yStart = y;
        end
        function SetEndPosition(obj,x,y)
            obj.xEnd = x;
            obj.yEnd = y;
        end
        function V = cost(obj,path)
            % A function to calculate the cast assosiated to a path. The
            % path is defined as a 3 by m vector with the x, y, t
            % coorditante in it.
            
            % Calculate the speed:
                ...
                    
            % Calculate the energy
                ...
            
            
        end
        function plot(obj,path)
            hold off
            surf(obj.X,obj.Y,(obj.clouds.*obj.sun))
            hold on
            hig = 0.*path(1,:)+3;
            plot3(path(2,:),path(1,:),hig,'LineWidth', 2);
            view([0,0,90])
        end
        function value = getSun(obj, x, y)
            % A method to return a function object 
            value = interp2(obj.X,obj.Y,obj.clouds.*obj.sun,x,y,'cubic');
        end
    end
    
    
end

