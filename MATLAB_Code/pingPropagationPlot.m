% This script produces a plot of ping propagation delay as a function of
% the angle of separation, Beta, between the ground station (gs) and the
% satellite. In other words, given the angle of separation between the gs
% and the satellite, how long would it take for a signal to reach the
% satellite, and then come back down to the gs?

latitudes = 0:0.1:80;

N = length(latitudes);

delays = zeros(1, N);

for i = 1:N
    delays(i) = GEO_Propagation_Delay_Calculator(latitudes(i),0,latitudes(i),0,0);
end

plot(latitudes, delays,'LineWidth', 1.75);
title("Ping Propagation Delay vs Angle of Separation")
xlabel("β, Angle of Separation [degrees]")
ylabel("Ping Propagation Delay [milliseconds]")
grid on;