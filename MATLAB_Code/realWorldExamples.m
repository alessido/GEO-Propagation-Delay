% Dominic Alessi
% 7/31/26

% This is a quick little program I threw together after doing a bit of 
% physics, geometry, and math to calculate the propagation delay between
% two ground stations communicating via a geostationary earth orbit
% (GEO) satellite.

% The user is prompted to enter the longitude of their GEO satellite, then
% the latitude and longitude of both of their ground stations.

clear; clc; close all;

%% Set Constants
R = 6371000; % radius of earth in meters
G = 6.6743e-11; % univeral gravitational constant, "Big G" [m^3/(kg * s^2)]
m = 5.972e24; % mass of earth in kg
w = 7.292e-5; % earth's angular velocity in rad/s
c = 299792458; % speed of light in m/s

% Derived constants
h = nthroot((G * m)/(w^2), 3) - R;
betaMax = acosd(R/(R+h)); % about 81 degrees

fprintf("GEO Satellite Propagation Delay Calculator\n");
fprintf("Created by Dominic Alessi\n\n");
fprintf("************************************************************\n\n")

% Get satellite info and convert to Cartesian
userInput = input('Enter GEO Satellite Longitude: ', 's');
satellite_longitude = str2double(userInput);
satellite_latitude = 0; % GEO, latitude is always zero
satellite_xyz = [cosd(satellite_longitude) * cosd(satellite_latitude), ...
    sind(satellite_longitude) * cosd(satellite_latitude), ...
    sind(satellite_latitude)];

% Get ground station 1 info and convert to Cartesian
userInput = input('Enter Ground Station 1 Latitude: ', 's');
gs1_latitude = str2double(userInput);
userInput = input('Enter Ground Station 1 Longitude: ', 's');
gs1_longitude = str2double(userInput);

gs1_xyz = [cosd(gs1_longitude) * cosd(gs1_latitude), ...
    sind(gs1_longitude) * cosd(gs1_latitude), ...
    sind(gs1_latitude)];

% Calculate angle of separation between gs1 and the satellite
betaOne = acosd(dot(gs1_xyz, satellite_xyz)/(sqrt(sum(gs1_xyz.^2)) * sqrt(sum(satellite_xyz.^2))));

% Check that gs1 and the satellite are within LOS
if (betaOne > betaMax)
    fprintf("Ground Station 1 and the GEO Satellite are NOT within line-of-sight.\nTerminating...")
    return
end

% Get ground station 2 info and convert to Cartesian
userInput = input('Enter Ground Station 2 Latitude: ', 's');
gs2_latitude = str2double(userInput);
userInput = input('Enter Ground Station 2 Longitude: ', 's');
gs2_longitude = str2double(userInput);

gs2_xyz = [cosd(gs2_longitude) * cosd(gs2_latitude), ...
    sind(gs2_longitude) * cosd(gs2_latitude), ...
    sind(gs2_latitude)];

% Calculate angle of separation between gs1 and the satellite
betaTwo = acosd(dot(gs2_xyz, satellite_xyz)/(sqrt(sum(gs2_xyz.^2)) * sqrt(sum(satellite_xyz.^2))));

% Check that gs2 and the satellite are within LOS
if (betaTwo > betaMax)
    fprintf("Ground Station 2 and the GEO Satellite are NOT within line-of-sight.\nTerminating...")
    return
end

% Scale unit vectors by their distance from earth's center
satellite_Rxyz = (h + R) * satellite_xyz;
gs1_Rxyz = R * gs1_xyz;
gs2_Rxyz = R * gs2_xyz;

fprintf("************************************************************\n")

% Calculate Distances
distanceVector1 = satellite_Rxyz - gs1_Rxyz;
distance1 = sqrt(sum(distanceVector1.^2));
fprintf("Propagation Distance Ground Station 1 to Satellite: %f km\n", distance1/1000);

distanceVector2 = satellite_Rxyz - gs2_Rxyz;
distance2 = sqrt(sum(distanceVector2.^2));
fprintf("Propagation Distance Ground Station 2 to Satellite: %f km\n", distance2/1000);
fprintf("Total Distance: %.4f km\n", (distance1 + distance2)/1000);
fprintf("Ground Station to Ground Station Propagation Delay: %f ms\n", ...
    1000 * (distance1 + distance2)/c);

%% Now we make a map of our ground stations and satellite

% Make the map and the satellite rings
figure
worldmap('World')
load coastlines
geoshow(coastlat, coastlon)

% Plot area of service with T > 130 ms
[latOuter, lonOuter] = scircle1(0, satellite_longitude, betaMax);
[latInner, lonInner] = scircle1(0, satellite_longitude, 56.1);
latRing = [latOuter; NaN; flipud(latInner)];
lonRing = [lonOuter; NaN; flipud(lonInner)];
geoshow(latRing, lonRing, 'DisplayType', 'polygon', ...
     'FaceColor', [1 0.6 0], 'FaceAlpha', 0.5, ...
     'EdgeColor', 'k', 'LineWidth', 1.25)

% Area of service with 120 ms < T < 130 ms
[latOuter, lonOuter] = scircle1(0, satellite_longitude, 56.1);
[latInner, lonInner] = scircle1(0, satellite_longitude, 12.7);
latRing = [latOuter; NaN; flipud(latInner)];
lonRing = [lonOuter; NaN; flipud(lonInner)];
geoshow(latRing, lonRing, 'DisplayType', 'polygon', ...
     'FaceColor', [1 1 0], 'FaceAlpha', 0.5, ...
     'EdgeColor', 'k', 'LineWidth', 1.25)
 
% Area of service with T < 120 ms
[latc, lonc] = scircle1(0, satellite_longitude, 12.7);
geoshow(latc, lonc, 'DisplayType', 'polygon', ...
     'FaceColor', [0.7 1.0 0.7], 'FaceAlpha', 0.5, ...
     'EdgeColor', 'k', 'LineWidth', 1.25)

% Plot satellite and ground stations
geoshow(0, satellite_longitude, 'DisplayType', 'point', 'Marker', 'o', 'MarkerFaceColor','b', 'MarkerEdgeColor', 'b') % satellite
geoshow(gs1_latitude, gs1_longitude, 'DisplayType', 'point', 'Marker', 'o', 'MarkerFaceColor','r', 'MarkerEdgeColor', 'r')
textm(gs1_latitude, gs1_longitude, append("  ", "GS1"), 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 10)
geoshow(gs2_latitude, gs2_longitude, 'DisplayType', 'point', 'Marker', 'o', 'MarkerFaceColor','r', 'MarkerEdgeColor', 'r')
textm(gs2_latitude, gs2_longitude, append("  ", "GS2"), 'Color', 'r', 'FontWeight', 'bold', 'FontSize', 10)

% Legend
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
