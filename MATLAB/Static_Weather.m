function [ Vcloud,VwindX,VwindY,X,Y ] = Static_Weather( seed,n,dx )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
rng(seed)

% n is a number that indecates the number of clouds...

[Xdummy,Ydummy] = meshgrid(0:n);
V = rand(n+1);

[X,Y] = meshgrid(0:dx:n);
Vcloud = interp2(Xdummy,Ydummy,V,X,Y);
[N,~] = size(Vcloud);

X = X./n;
Y = Y./n;
m = max([max(max(Vcloud)),abs(min(min(Vcloud)))]);
Vcloud = Vcloud./m;



%% Generating the wind
V = rand(n+1);
[Xdummy,Ydummy] = meshgrid(0:n);
[X,Y] = meshgrid(0:dx:n);
VwindX = interp2(Xdummy,Ydummy,V,X,Y);
V = rand(n+1);
VwindY = interp2(Xdummy,Ydummy,V,X,Y);

X = X./n;
Y = Y./n;
mx = max([max(max(VwindX)),abs(min(min(VwindX)))]);
my = max([max(max(VwindY)),abs(min(min(VwindY)))]);
VwindX = VwindX./mx;
VwindY = VwindY./my;
figure(2)

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

