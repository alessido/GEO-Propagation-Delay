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
betaMax = acosd(R/(R+h));

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




