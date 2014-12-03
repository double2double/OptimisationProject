function [ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( seed,n ,m)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
rng(seed)

% n is a number that indecates the number of clouds...

[Xdummy,Ydummy] = meshgrid(0:n);
V = rand(n+1);
mesh(V)
[X,Y] = meshgrid(linspace(0,n,m));
Vcloud = interp2(Xdummy,Ydummy,V,X,Y);
surf(Vcloud)
maxi = max([max(max(Vcloud)),abs(min(min(Vcloud)))]);
Vcloud = Vcloud./maxi;

% Generating the wind

V = rand(n+1);
VwindX = interp2(Xdummy,Ydummy,V,X,Y);
maxi = max([max(max(VwindX)),abs(min(min(VwindX)))]);
VwindX = VwindX./maxi;
[Xdummy,Ydummy] = meshgrid(0:n);
V = rand(n+1);
mesh(V)
[X,Y] = meshgrid(linspace(0,n,m));
VwindY = interp2(Xdummy,Ydummy,V,X,Y);
surf(VwindY)
[N,~] = size(VwindY);

maxi = max([max(max(VwindY)),abs(min(min(VwindY)))]);
VwindY = VwindY./maxi;


X = X./n;
Y = Y./n;

subplot(1,2,1)
surf(X,Y,Vcloud);
title('Cloud density');
view(0,90)
hold on
subplot(1,2,2)
quiver(X,Y,VwindX,VwindY);
axis([0,1,0,1])
hold off
title('Wind direction');



end

