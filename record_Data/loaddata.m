
fileIMU = load("test2_IMU1_modified.txt");
gyro = fileIMU(:, 1:3);
accel = fileIMU(:, 4:6);
inklin = fileIMU(:, 7:9);
imutimes = fileIMU(:, 10);

%%
clear fileIMU pos x y gpstimes lat long alt angle
j=1;
k=1;
fileIMU = fileread("TEST2_GPS1.TXT");
msgnum = count(fileIMU, "$");
lines = split(fileIMU, "$");

gps_strings(j) = "test";
angle_strings(k) = "test";

for i = 2:msgnum+1 
    %lines{i}
    if lines{i}(1:5) == "GPGGA"                           % Find GPGGA messages
        gps_strings(j) = lines{i}; 
        charline = char(gps_strings(j));                            % string2char
        %long(j) = str2double(string(charline(17:28)));              % Get longitudinar datas
        %lat(j) = str2double(string(charline(32:44)));               % Get latitude datas
        tmp = split(charline, newline);
        gpstimes(j)= str2double(tmp{2}(2:end));
        coords = nmealineread(['$', tmp{1}]);
        long(j)=coords.longitude;
        lat(j)=coords.latitude;
        alt(j)=coords.altitude;
        
        
        j = j + 1;
        
    elseif lines{i}(1:4) == "PTNL"                        % Find angle messages
        angle_strings(k) = lines{i};
        %start = strfind(angle_strings(k),'0,+');                    % Starting point of angle data
        %ending = strfind(angle_strings(k),',Yaw');                  % Ending point of angle data
        charline = char(angle_strings(k));                          % string2char
        fields = split(charline, ',');
        angle(k) = str2double(string(fields{4}));
        if angle(k) == 0                                            % If we lost data our angle became exatly zero
            angle(k) = angle(k-1);
        end
        k = k + 1;
    end
end

pos = lla2flat([lat; long; alt]', [lat(1), long(1)], 0,0);
x=pos(:, 1);
y=pos(:, 2);

for i = 2:length(angle)
    if angle(i) < angle(i-1)-180
        angle(i:end) = angle(i:end) + 360;
    end
    if angle(i) > angle(i-1)+180
        angle(i:end) = angle(i:end) - 360;
    end
end
%% PLOT GPS COORDINATE. +Assorted plots.
startiso = 24114;
endiso = 25327;
figure(1)
plot(x,y)
title("Position across testing");xlabel("distance in x [m]");ylabel("distance in y [m]")
figure(2)
subplot(1,2,1)
plot(x)
title("Position in x over time");xlabel("Samples");ylabel("Distance from start [m]")
subplot(1,2,2)
plot(y)
title("Position in y over time");xlabel("Samples");%ylabel("Distance from start [m]")
figure(3)
xlim = x(startiso:endiso);  %putting limiters on x and y to isolate specific time
ylim = y(startiso:endiso);
subplot(1,2,1)
plot(xlim)
title("Isolated driving test, x axis travel"); xlabel("Samples");ylabel("Distance from start [m]")
subplot(1,2,2)
plot(ylim)
title("Isolated driving test, y axis travel"); xlabel("Samples");%ylabel("Distance from start [m]")
figure(4)
plot(xlim,ylim, 'LineWidth', 1)
title("Isolated driving test GPS position");xlabel("Travel in x-axis[m]");ylabel("Travel in y-axis[m]")
pos = [xlim, ylim];

figure(5)
for k = 2:1214
    vel(k) = sqrt((xlim(k)-xlim(k-1))^2+(ylim(k)-ylim(k-1))^2)*20;  %times 20 to account for 20Hz sensor frequency.
end
plot(vel)
title("The velocity during isolated testing scenario");xlabel("Samples");ylabel("Velocity [m/s]")
%%  Calculations based on Velocity
vell = vel(256:1040);
vella = mean(vell);     %Rejzi - average velocity during racecar circle drive test.
istesttime = gpstimes(25327)-gpstimes(24114)


%%
accang(1)=0+226.4864;   %Correcting IMU angle reading to have same starting angle.
for i = 1:length(gyro)
    accang(i+1) = accang(i) + gyro(i,1);
end
new_gps_angle = interp1(linspace(0,1,length(angle)), angle, linspace(0,1,length(accang)));

%%  PLOT GPS/IMU ANGLE
figure(6)
plot(accang)
hold on
plot(new_gps_angle)
legend("IMU", "GPS")
title("Vehicle angle")
xlabel("Time")
ylabel("Angle(degrees)")
hold off
%% Calc error between IMU and Angle
testing = [];
for i = 1:length(accang)
    testing(i) = new_gps_angle(i)-accang(i);%GPS-IMU error at every time.
end
testingrmse = sqrt(mean((testing).^2));   %root_mean_square_error
testingmse = sum(abs((testing).^2))/length(new_gps_angle);    %mean_square_error
testingmean = mean(testing);
testingsum = sum(testing);
figure(7)
plot(testing)
%% 
anglelim = angle(startiso:endiso);
gpstimeslim = gpstimes(startiso:endiso);
for i = 1:length(gpstimeslim)
    gpstimeslims(i) = gpstimeslim(i)-gpstimes(startiso);
end
figure(8)
plot(gpstimeslims,anglelim)
hold on
plot(gpstimeslims(j1),max(anglelim),'*')
hold on
plot(gpstimeslims(j2),min(anglelim),'*')
hold off
%%
%fuse = imufilter('SampleRate', 125);
%q=fuse(accel, gyro*125);

1+1