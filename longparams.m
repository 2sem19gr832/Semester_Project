clear all

m=296;        %Mass of the car (Kg)
Jw = 12;
Cd = 0.3;     %Coefficient of Friction
A = 1.5;      %Frontal surface area (m^2)
Rho = 1.29;   %Air Density (kg/m^3)
g = 9.8;
Theta = 0;


%rpmToTorque=400+((x-1000)*100/3500); %Linear Pedal
Ktor=1;  %Consider input as engine torque
ig= 1.9370; %Gear Ratio for 2nd gear
id= 7.91;   %Differential Ratio
Rw=0.26;  %0.5207/2; %Wheel Radius (m)
mt = m + Jw/(Rw^2);
lr = 0.9;
lf = 1.1;
l = lr+lf; %Length of the Vehicle (m)
pi= pi();

