% Takes the satellite longitude and 2 3x1 columns in the form of:

% name
% latitude
% longitude

% and then prints a message about the propagation delay

function blankToBlank(sat_longitude, gs1, gs2)
    
    % Get propagation delay
    delay = GEO_Propagation_Delay_Calculator(gs1{2,1}, gs1{3,1}, gs2{2,1}, gs2{3,1},sat_longitude);
    
    % Latitude/Longitude in string form
    gs1_lat = northOrSouth(gs1{2,1});
    gs1_lon = eastOrWest(gs1{3,1});
    gs1_name = gs1{1,1};
    gs2_lat = northOrSouth(gs2{2,1});
    gs2_lon = eastOrWest(gs2{3,1});
    gs2_name = gs2{1,1};


    fprintf("%s (%s,%s) to %s (%s,%s): %.2f ms\n", gs1_name, gs1_lat, gs1_lon, gs2_name, gs2_lat, gs2_lon, delay);
end