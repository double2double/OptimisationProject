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
        end % Constructor method
        function obj = SetStartPosition(x,y)
            obj.xStart = x;
            obj.YStart = y;
        end
        function obj = SetEndPosition(x,y)
            obj.xEnd = x;
            obj.YEnd = y;
        end
        function obj = cost(path)
            % A function to calculate the cast assosiated to a path. The
            % path is defined as a 3 by m vector with the x, y, t
            % coorditante in it.
            
            
        end
        
    end
    
    
end

