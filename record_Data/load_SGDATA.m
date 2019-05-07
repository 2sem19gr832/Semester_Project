%Create plot of overall angle with marker at every reset
%Separate each 'test' into its own dataset.
%plot steering angle for each test, with its time.

%% SG_DATA reformulation
%sg = strain gauge, pot = potentiometer
% Startmeas, postsgmeas, postpotmeas, pullF, tieF, LRF, LFF, URF, UFF, pullR, tieR, LRR, LFR, URR, UFR, rat, RLs, FLs, FRs, RRs
clear, clc
file = fileread("SG_DATA.txt");
readings = split(file, "RESET");
readings(1:8,:) = [];
TotalTime = 0;
for i=1:18          
    
    test{i,1} = str2num(cell2mat(readings(i)));
    
    SGDATA{i,1} = struct('duration',[(test{i}(size(test{i},1),3)-test{i}(1,1))/1000],'times',[test{i}(:,1:3)],'sg',[test{i}(:,4:15)],'pots',[test{i}(:,16)/1024*300-150 test{i}(:,17:20)]);   %initializing SGDATA cell array
    TotalTime = TotalTime+SGDATA{i}.duration;   %Total testing duration in seconds.
    figure(1)
    hold on
    plot(SGDATA{i}.pots(:,1))% SGDATA{i}.pots(:,1)) is steering wheel angle in degrees.
    
end



%function 

%%

SG_times = A(:,1:3);
t1 = (SG_times(73190,3)-SG_times(1,1))/1000;
tott = duration(0,0,t1);        %recording duration
SG_sg = A(:,4:15);
SG_pots = A(:,16:20);

%% Steering angle
steer = SG_pots(:,1);
for i = 1:length(steer)
    steering(i) = steer(i)/1024*300-150;
end
plot(SG_times(:,1),steering)
