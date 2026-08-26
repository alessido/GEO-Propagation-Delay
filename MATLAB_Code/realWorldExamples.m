clear; clc; close all;

% Pull data from .txt file
data = parseData('places.txt');

satLon = -100; % Define satellite to be 100 degrees West
betaMax = 81.3;% Define max LOS area

%% Calculate propagation delays for real-world places
% Anchorage Alaska to the Falkland Islands
blankToBlank(satLon, data(:,1), data(:,2));

% Corvallis to Buenos Aires
blankToBlank(satLon, data(:,5), data(:,3));

% LA to Sao Paulo
blankToBlank(satLon, data(:,6), data(:,4));

% Mexico City to Panama
blankToBlank(satLon, data(:,7), data(:,8));

%% Create map
figure
worldmap('World')
load coastlines
geoshow(coastlat, coastlon)

% Plot area of service with T > 130 ms
[latOuter, lonOuter] = scircle1(0, satLon, betaMax);
[latInner, lonInner] = scircle1(0, satLon, 56.1);
latRing = [latOuter; NaN; flipud(latInner)];
lonRing = [lonOuter; NaN; flipud(lonInner)];
geoshow(latRing, lonRing, 'DisplayType', 'polygon', ...
     'FaceColor', [1 0.6 0], 'FaceAlpha', 0.5, ...
     'EdgeColor', 'k', 'LineWidth', 1.25)

% Area of service with 120 ms < T < 130 ms
[latOuter, lonOuter] = scircle1(0, satLon, 56.1);
[latInner, lonInner] = scircle1(0, satLon, 12.7);
latRing = [latOuter; NaN; flipud(latInner)];
lonRing = [lonOuter; NaN; flipud(lonInner)];
geoshow(latRing, lonRing, 'DisplayType', 'polygon', ...
     'FaceColor', [1 1 0], 'FaceAlpha', 0.5, ...
     'EdgeColor', 'k', 'LineWidth', 1.25)
 
% Area of service with T < 120 ms
[latc, lonc] = scircle1(0, satLon, 12.7);
geoshow(latc, lonc, 'DisplayType', 'polygon', ...
     'FaceColor', [0.7 1.0 0.7], 'FaceAlpha', 0.5, ...
     'EdgeColor', 'k', 'LineWidth', 1.25)


% Plot places and label them

geoshow(0, satLon, 'DisplayType', 'point', 'Marker', 'o', 'MarkerFaceColor','b', 'MarkerEdgeColor', 'b') % satellite

for i = 1:length(data)
    geoshow(data{2,i}, data{3,i}, 'DisplayType', 'point', 'Marker', 'o', 'MarkerFaceColor','r')
    textm(data{2,i}, data{3,i}, append("  ", data{1,i}), 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 10)
end

% Lastly, add a legend to the map
hold on
% Proxy handles for legend (invisible, just for shape/color reference)
h1 = plot(NaN, NaN, 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'MarkerSize', 8);
h2 = plot(NaN, NaN, 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 8);
h3 = plot(NaN, NaN, 's', 'MarkerFaceColor', [1 0.6 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 10);
h4 = plot(NaN, NaN, 's', 'MarkerFaceColor', [1 1 0], 'MarkerEdgeColor', 'k', 'MarkerSize', 10);
h5 = plot(NaN, NaN, 's', 'MarkerFaceColor', [0.7 1 0.7], 'MarkerEdgeColor', 'k', 'MarkerSize', 10);

legend([h1 h2 h3 h4 h5], ...
    {'Ground Stations', 'GEO Satellite', 'T_p > 130 ms', '120 ms < T_p < 130 ms', 'T_p < 120 ms'}, ...
    'Location', 'northwest')
    
