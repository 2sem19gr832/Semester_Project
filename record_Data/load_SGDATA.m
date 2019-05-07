%Create plot of overall angle with marker at every reset
%Separate each 'test' into its own dataset.
%plot steering angle for each test

%% SG_DATA reformulation
%sg = strain gauge, pot = potentiometer
% Startmeas, postsgmeas, postpotmeas, pullF, tieF, LRF, LFF, URF, UFF, pullR, tieR, LRR, LFR, URR, UFR, rat, RLs, FLs, FRs, RRs
clear, clc
file = fileread("SG_DATA.txt");
readings = split(file, "RESET");
readings(1:8,:) = [];
TotalTime = 0;
Angles = [];
MaxDur = 3.369135000000000e+03;
for i=1:18          
    
    test{i,1} = str2num(cell2mat(readings(i)));
    
    SGDATA{i,1} = struct('duration',[(test{i}(size(test{i},1),3)-test{i}(1,1))/1000],'times',[(test{i}(:,1)-test{i}(1,1))/1000 test{i}(:,2:3)/1000],'sg',[test{i}(:,4:15)],'pots',[test{i}(:,16)/1024*300-150 test{i}(:,17:20)/1024*60]);   %initializing SGDATA cell array
    TotalTime = TotalTime+SGDATA{i}.duration;   %Total testing duration in seconds.
    Angles = [Angles ; SGDATA{i}.pots(:,1); 200];   %All angles in one vector with markers set to 200 at each reset.
    figure(19)   %Steering angle plot
    hold on
    plot(SGDATA{i}.pots(:,1))% SGDATA{i}.pots(:,1)) is steering wheel angle in degrees.
    %Plots all different angle tests in same figure.
end
1+1
%SGDATA{i}.pots(:,1)    ACCESS STEERING WHEEL ANGLE [deg]
%SGDATA{i}.pots(:,2:4)  SUSPENSION TRAVEL [MM]

%%  Separate Plotting
%for j = 1:18       %For plotting all of the steering angle in separate figures
%    figure(j)
%    plot(SGDATA{j}.times(:,1),SGDATA{j}.pots(:,1)) %angle
%    hold on
%    plot(SGDATA{j}.times(:,1),SGDATA{j}.pots(:,5)) %Rear right suspension.
%    hold off
%end

ar = [6 8 11 14 16 18];
figure(21)
for j = 1:6 %Plotting angle and all suspension on same figure.
    subplot(2,3,j)
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,1))
        hold on
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,2))  %faulty.
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,3))
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,4))
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,5))
        
        legend("rat", "RLs", "FLs", "FRs", "RRs")
        hold off
end

%~6.4 seconds per rotation/encirclement