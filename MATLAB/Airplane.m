classdef Airplane
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        clouds = [];
        windX = [];
        windY = [];
        X = [];
        Y = [];
        power = 0;
        xStart = 0;
        yStart = 0;
        xDestin = 0;
        yDestin = 0;
    end
    methods
        function obj = Airplane(clouds,windX,windY,X,Y)
            obj.clouds = clouds;
            obj.windX = windX;
            obj.windY = windY;
            obj.X = X;
            obj.Y = Y;
        end % Constructor method
        function obj = SetStartPosition(x,y)
            obj.xStart = x;
            obj.YStart = y;
        end
    end
    
    
end

