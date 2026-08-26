% This script produces a plot of the propagation delay as a function of
% the angle of separation, Beta, between the ground station (gs) and the
% satellite. In other words, given the angle of separation between the gs
% and the satellite, how long would it take for a signal to reach the
% satellite?

latitudes = 0:0.1:80;

N = length(latitudes);

delays = zeros(1, N);

for i = 1:N
    delays(i) = GEO_Propagation_Delay_Calculator(latitudes(i),0,latitudes(i),0,0)/2;
end

plot(latitudes, delays,'LineWidth', 1.75);
title("Propagation Delay vs Angle of Separation")
xlabel("β, Angle of Separation [degrees]")
ylabel("Propagation Delay [milliseconds]")
grid on;

% yline([120, 130], 'r', {'120 milliseconds','130 milliseconds'})

% yline(120, 'Color', [1 1 0], '120 milliseconds')

yline(120, '-', '120 milliseconds', 'Color', 'g', 'LineWidth', 2);
yline(130, '-', '130 milliseconds', 'Color', [1 0.65 0.05], 'LineWidth', 2);

