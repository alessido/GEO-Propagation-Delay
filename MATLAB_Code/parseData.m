function locMatrix = parseData(filename)
% PARSELOCATIONS Parses a comma-delimited text file of "Name,Num1,Num2"
% rows into a 3-by-N cell matrix: row 1 = names, row 2 = first number,
% row 3 = second number (one column per entry).
%
%   locMatrix = parseLocations('data.txt')
%
%   Input file format (one location per line):
%       Mexico City,19.4,-99.1
%       New York City,40.7,-74
%
%   Output:
%       locMatrix{1,1} = 'Mexico City'   locMatrix{1,2} = 'New York City'
%       locMatrix{2,1} = 19.4            locMatrix{2,2} = 40.7
%       locMatrix{3,1} = -99.1           locMatrix{3,2} = -74

    fid = fopen(filename, 'r');
    if fid == -1
        error('parseLocations:fileNotFound', 'Could not open file: %s', filename);
    end

    names = {};
    num1  = [];
    num2  = [];

    lineNum = 0;
    while true
        line = fgetl(fid);
        if ~ischar(line)   % end of file
            break;
        end
        lineNum = lineNum + 1;

        line = strtrim(line);
        if isempty(line)
            continue;      % skip blank lines
        end

        parts = strsplit(line, ',');
        if numel(parts) ~= 3
            warning('parseLocations:badLine', ...
                'Line %d does not have exactly 3 fields, skipping: %s', lineNum, line);
            continue;
        end

        names{end+1}  = strtrim(parts{1});         %#ok<AGROW>
        num1(end+1)   = str2double(parts{2});       %#ok<AGROW>
        num2(end+1)   = str2double(parts{3});       %#ok<AGROW>
    end

    fclose(fid);

    % Assemble the 3-by-N cell matrix: row1 = names, row2/row3 = numbers
    n = numel(names);
    locMatrix = cell(3, n);
    locMatrix(1, :) = names;
    locMatrix(2, :) = num2cell(num1);
    locMatrix(3, :) = num2cell(num2);
end