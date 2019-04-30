


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
 
%plot(t, theta_rad)
%scatter(x,y)
