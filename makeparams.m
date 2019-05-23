clear all

% Sample time
Ts = 0.1;

%Velocity
Vx = 15;

% Model parameters
% m = 293;
% lw = 1.4;
% Ltotal = 2.3;
% Iz = m*(lw^2 + Ltotal^2)/12;
% lf = 0.85;
% lr = 0.75;
% Cf = 2200;
% Cr = 3000;

m = 1575;
Iz = 2875;
lf = 1.2;
lr = 1.6;
Cf = 19000;
Cr = 33000;

clear Ltotal lw

% Continuous-time model
A = [-(2*Cf+2*Cr)/m/Vx, 0, -Vx-(2*Cf*lf-2*Cr*lr)/m/Vx, 0;
     0, 0, 1, 0;
     -(2*Cf*lf-2*Cr*lr)/Iz/Vx, 0, -(2*Cf*lf^2+2*Cr*lr^2)/Iz/Vx, 0;
     1, Vx, 0, 0];
B = [2*Cf/m 0 2*Cf*lf/Iz 0]';   
C = [0 0 0 1; 0 1 0 0];
D = zeros(2,1);

% refstruct = SkidpadMatFunc();
refstruct = newSkidpad();
for i = 1:size(refstruct,2)
    Yaw(i) = refstruct(i).ActorPoses.Yaw;
    Time(i) = refstruct(i).Time;
end
refYaw = [Time', deg2rad(Yaw')];





