%%% Circle
x=cosd(1:360)*9+9;
y=sind(1:360)*9;
trajectory_angle=(1:360)/360*2*pi;

%%% SKIDPAD
%y= [0:0.1:9, cosd((1:360)-90)*9+9];
%x= [zeros(1,91),sind((1:360)-90)*9+9];
%trajectory_angle = [ones(1,91)*pi,(1:360)/360*2*pi];


%%% 90 deg turn
%y= [(1:200), ones(1,200)*200];
%x= [zeros(1,200),(1:200)];
%trajectory_angle = [ones(1,200)*1/2*pi, zeros(1, 200)];

%%% Sinosiod Movement
%x = (0:0.1:47.9);
%y = [zeros(1, 10), sind(1:360)*18, sind(1:90)*18, ones(1, 20)*18];
downsamplex = posOri(1:16:end, 1);
downsampley = posOri(1:16:end, 2);
errorx = x' - downsamplex(1:360);
errory = y' - downsampley(1:360);
%dist = sqrt(errorx.^2 + errory.^2);

mean(abs(errory))
plot(x,y)
hold on
plot(posOri(:, 1), posOri(:, 2))
hold off

%%
for t = 2:480
    deltax(t) = x(t)-x(t-1);
    deltay(t) = y(t)-y(t-1);
    theta_rad(t) = atan2(deltay(t), deltax(t));
end

figure(1)
%title('Sinosoid Reference')
subplot(2,1,1)
plot(x, y)
title('Reference Trajectory')
ylabel('Position [m]')
xlabel('Position [m]')
subplot(2,1,2)
plot(theta_rad(1, 1:470)*180/pi)
title('Reference Yaw Angle')
ylabel('Angle [deg]')
xlabel('Time Step')





%%% Circle
%figure(1)
%subplot(2,1,1)
%plot(x, y)
%title('Reference Trajectory')
%ylabel('Position [m]')
%xlabel('Position [m]')
%subplot(2,1,2)
%plot(theta_rad(1, 1:470)*180/pi)
%title('Reference Yaw Angle')
%ylabel('Angle [deg]')
%xlabel('Time Step')
%%
%subplot(3, 1, 3)
plot(position(:, 1)/15.5031, position(:, 2  ))
hold on
plot(x, y)
title('Comparison of Reference and model output (Hu = 3, Hp = 10)')
xlabel('Position [m]')
ylabel('Position [m]')
legend('Model Output', 'Reference')
hold off
