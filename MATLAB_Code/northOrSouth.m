% Takes positive latitudes and adds "°N" to the end. 
% For negative latitudes, removes the negative and puts "°S" to the end
function myString = northOrSouth(latitude)
    
    if(latitude >= 0)
        myString = append(string(latitude), "°N");
    else
        myString = append(string(abs(latitude)), "°S");
    end
end