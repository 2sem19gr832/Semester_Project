%Create plot of overall angle with marker at every reset
%Separate each 'test' into its own dataset.
%plot steering angle for each test

%% SG_DATA reformulation
%sg = strain gauge, pot = potentiometer
% Startmeas, postsgmeas, postpotmeas, pullF, tieF, LRF, LFF, URF, UFF, pullR, tieR, LRR, LFR, URR, UFR, rat, RLs, FLs, FRs, RRs

fileArd = fileread("SG_DATA.txt");
readings = split(fileArd, "RESET");
readings(1:8,:) = [];
TotalTime = 0;
Angles = [];
MaxDur = 3.369135000e+03;     %Maximum duration for any given test.
for i=1:18
    
    readsplit{i,1} = str2num(cell2mat(readings(i)));
    
    SGDATA{i,1} = struct('duration',[(readsplit{i}(size(readsplit{i},1),3)-readsplit{i}(1,1))/1000],'times',[(readsplit{i}(:,1)-readsplit{i}(1,1))/1000 readsplit{i}(:,2:3)/1000],'sg',[readsplit{i}(:,4:15)],'pots',[readsplit{i}(:,16)/1024*300-150 readsplit{i}(:,17:20)/1024*60]);   %initializing SGDATA cell array
    TotalTime = TotalTime+SGDATA{i}.duration;   %Total testing duration in seconds.
    Angles = [Angles ; SGDATA{i}.pots(:,1); 200];   %All angles in one vector with markers set to 200 at each reset.
    figure(19)   %Steering angle plot
    hold on
    plot(SGDATA{i}.pots(:,1))% SGDATA{i}.pots(:,1)) is steering wheel angle in degrees.
    %Plots all different angle tests in same figure.
end

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
    %Steering wheel at 0 = neutral, >0 = left, <0 = right.
    %subplot(2,3,j)
    figure(19+j)
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,1))
        hold on
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,2))  %RearLeft
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,3))  %FrontLeft
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,4))  %FrontRight
        plot(SGDATA{ar(j)}.times(:,1),SGDATA{ar(j)}.pots(:,5))  %RearRight
        hold off
        title("Test "+j)
        xlabel("Time[s]")
        if j == 1 || 4 
            ylabel("Angle[deg] / Suspension travel [mm]")
        end
        legend("Wheel", "RLs", "FLs", "FRs", "RRs")
        %ylabel("test")
        set(gca,'xtick',[0:is2time:length(SGDATA{ar(j)}.pots(:,1))])
        grid on
        hold off
        
end
%% isolating datasets:

SGisolt5 = [SGDATA{ar(5)}.pots(1:61.5220,1)];
SGisolt52 = [interp1(linspace(0,1,length(SGDATA{ar(5)}.pots(1:61.5220,1))), SGDATA{ar(5)}.pots(1:61.5220,1)', linspace(0,1,length(accang)));
            interp1(linspace(0,1,length(SGDATA{ar(1)}.pots(1:61.5220,1))), SGDATA{ar(1)}.pots(1:61.5220,1)', linspace(0,1,length(accang)));
            interp1(linspace(0,1,length(SGDATA{ar(2)}.pots(1:61.5220,1))), SGDATA{ar(2)}.pots(1:61.5220,1)', linspace(0,1,length(accang)));
            interp1(linspace(0,1,length(SGDATA{ar(3)}.pots(1:61.5220,1))), SGDATA{ar(3)}.pots(1:61.5220,1)', linspace(0,1,length(accang)));
            interp1(linspace(0,1,length(SGDATA{ar(4)}.pots(1:61.5220,1))), SGDATA{ar(4)}.pots(1:61.5220,1)', linspace(0,1,length(accang)))];
isolt5gp = [SGisolt52; accang; new_gps_angle];
size(isolt5gp)  %attempt plot of this, against time frame


%~6.4 seconds per rotation/encirclement
1+1