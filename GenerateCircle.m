


r = 18;
t = [1];
for a = 2:360
    x(a)=r*cosd(a);
    y(a)=r*sind(a);
    t(a) = t(a-1)+1;
    deltax(a) = x(a)-x(a-1);
    deltay(a) = y(a)-y(a-1);
    theta_rad(a) = atan2(deltay(a), deltax(a));
end



deltax(1) = deltax(3);
deltax(2) = deltax(3);

deltay(1) = deltay(3);
deltay(2) = deltay(3);

plot(t, deg90)
hold on
plot(deg90(1, 1:90), t(1:90))
%plot(t(1:90),20)
%plot(x(:,2:end),y(:,2:end))
