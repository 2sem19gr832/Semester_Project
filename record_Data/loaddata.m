
test = load("test2_IMU1_modified.txt");
gyro = test(:, 1:3);
accel = test(:, 4:6);
inklin = test(:, 7:9);
imutimes = test(:, 10);

%%
clear test pos x y gpstimes lat long alt angle
j=1;
k=1;
test = fileread("TEST2_GPS1.TXT");
msgnum = count(test, "$");
lines = split(test, "$");

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



%%
accang(1)=0;
for i = 1:length(gyro)
    accang(i+1) = accang(i) + gyro(i,1);
end

%%
fuse = imufilter('SampleRate', 125);
q=fuse(accel, gyro*125);

