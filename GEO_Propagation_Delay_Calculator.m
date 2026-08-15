function prop_delay = GEO_Propagation_Delay_Calculator(gs1_latitude, gs1_longitude, gs2_latitude, gs2_longitude, satellite_longitude)

    prop_delay = Inf;

    %% Set Constants
    R = 6371000; % radius of earth in meters
    G = 6.6743e-11; % univeral gravitational constant, "Big G" [m^3/(kg * s^2)]
    m = 5.972e24; % mass of earth in kg
    w = 7.292e-5; % earth's angular velocity in rad/s
    c = 299792458; % speed of light in m/s
    satellite_latitude = 0;
    
    % Derived constants
    h = nthroot((G * m)/(w^2), 3) - R;
    betaMax = acosd(R/(R+h));

    % Convert to Cartesian
    satellite_xyz = [cosd(satellite_longitude) * cosd(satellite_latitude), ...
    sind(satellite_longitude) * cosd(satellite_latitude), ...
    sind(satellite_latitude)];

    gs1_xyz = [cosd(gs1_longitude) * cosd(gs1_latitude), ...
    sind(gs1_longitude) * cosd(gs1_latitude), ...
    sind(gs1_latitude)];

    gs2_xyz = [cosd(gs2_longitude) * cosd(gs2_latitude), ...
    sind(gs2_longitude) * cosd(gs2_latitude), ...
    sind(gs2_latitude)];

    % Calculate angles of separation
    betaOne = acosd(dot(gs1_xyz, satellite_xyz)/(sqrt(sum(gs1_xyz.^2)) * sqrt(sum(satellite_xyz.^2))));
    betaTwo = acosd(dot(gs2_xyz, satellite_xyz)/(sqrt(sum(gs2_xyz.^2)) * sqrt(sum(satellite_xyz.^2))));

    % Assert both angles of separation are less than betaMax
    if ((betaOne > betaMax) || (betaTwo > betaMax))
        fprintf("One or more ground stations are not withing LOS of the satellite.")
        return;
    end

    % Also check that all latitudes are less than or equal to 90
    if((gs1_latitude > 90) || (gs2_latitude > 90))
        return;
    end

    % Scale unit vectors by their distance from earth's center
    satellite_Rxyz = (h + R) * satellite_xyz;
    gs1_Rxyz = R * gs1_xyz;
    gs2_Rxyz = R * gs2_xyz;

    % Calculate Distances
    distanceVector1 = satellite_Rxyz - gs1_Rxyz;
    d1 = sqrt(sum(distanceVector1.^2));
    
    distanceVector2 = satellite_Rxyz - gs2_Rxyz;
    d2 = sqrt(sum(distanceVector2.^2));

    total_d = d1 + d2;

    prop_delay = 1000 * total_d / c; % returns answer in milliseconds

end