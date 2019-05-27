%%% Circle
%x=cosd(1:360)*9+9;
%y=sind(1:360)*9;
%trajectory_angle=(1:360)/360*2*pi;

%%% SKIDPAD
%y= [0:0.1:9, cosd((1:360)-90)*9+9];
%x= [zeros(1,91),sind((1:360)-90)*9+9];
%trajectory_angle = [ones(1,91)*pi,(1:360)/360*2*pi];


%%% 90 deg turn
%y= [(1:200), ones(1,200)*200];
%x= [zeros(1,200),(1:200)];
%trajectory_angle = [ones(1,200)*1/2*pi, zeros(1, 200)];

%%% Sinosiod Movement
x = (0:0.1:47.9);
y = [zeros(1, 10), sind(1:360)*18, sind(1:90)*18, ones(1, 20)*18];


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
axis([-2 20 -11 11])
subplot(2,1,2)
plot(trajectory_angle(1, :)*180/pi)
axis([-10 400 0 400])
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
figure(1)
subplot(2, 1, 1)
plot(position(:, 1)/15.5031, position(:, 2))
hold on
plot(x, y)
title('Comparison of Reference and model output (Hu = 3, Hp = 10)')
xlabel('Position [m]')
ylabel('Position [m]')
legend('Model Output', 'Reference')
hold off
subplot(2, 1, 2)
fixedsize= [position(:, 1)/15.5031, position(:, 2)]';
errorx = position(1:480, 1)- x(1, :)';
errory = position(1:480, 2) - y(1, :)';
dist = sqrt(errorx.^2 + errory.^2);
%tx = finddelay(position(1:480, 1), x(1, :));
%ty = finddelay(position(1:480, 2), y(1, :));
plot(errorx, errory)
title('Positional Error')
ylabel('Position [m]')
xlabel('Time step')
%%
plot(Openloopstep(1:10:480, 1))
hold on
plot(Openloopstep(1:10:480, 2))
xlabel('Position [m]')
ylabel('Position [m]')
title('Comparison of Reference Position')
legend('Reference', 'Model Output')

error = Openloopstep(1:10:480, 1)-Openloopstep(1:10:480, 2);

meanerror = mean(abs(error))

hold off
%plot((1:0.1:49.9), Openloopstep(:, 1))
%hold on 
%plot((1:0.1:49.9), Openloopstep(:, 2))
%magnifyOnFigure;
    