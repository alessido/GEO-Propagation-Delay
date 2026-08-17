% Takes positive longitudes and adds "°E" to the end. 
% For negative longitudes, removes the negative and puts "°W" to the end
function myString = eastOrWest(longitude)
    
    if(longitude >= 0)
        myString = append(string(longitude), "°E");
    else
        myString = append(string(abs(longitude)), "°W");
    end
end