function [ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( seed,n ,m)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
rng(seed)

% n is a number that indecates the number of clouds...

[Xdummy,Ydummy] = meshgrid(0:n);
V = rand(n+1);
[X,Y] = meshgrid(linspace(0,n,m));
Vcloud = interp2(Xdummy,Ydummy,V,X,Y,'cubic');
maxi = max([max(max(Vcloud)),abs(min(min(Vcloud)))]);
Vcloud = Vcloud./maxi;

% Generating the wind

V = rand(n+1);
VwindX = interp2(Xdummy,Ydummy,V,X,Y,'cubic');
maxi = max([max(max(VwindX)),abs(min(min(VwindX)))]);
VwindX = VwindX./maxi;
[Xdummy,Ydummy] = meshgrid(0:n);
V = rand(n+1);
[X,Y] = meshgrid(linspace(0,n,m));
VwindY = interp2(Xdummy,Ydummy,V,X,Y,'cubic');
[N,~] = size(VwindY);

maxi = max([max(max(VwindY)),abs(min(min(VwindY)))]);
VwindY = VwindY./maxi;


X = X./n;
Y = Y./n;




end

