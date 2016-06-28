classdef StatisticTypes
    % StatisticTypes
    
    properties
        displayString
        filenameString
    end
    
    enumeration
        mean     ('Mean', 'Mean')
        median   ('Median', 'Median');
        stdev    ('Standard Deviation', 'St. Dev.');
        skewness ('Skewness', 'Skewnewss');
    end
    
    methods
        function enum = StatisticTypes(displayString, filenameString)
            enum.displayString = displayString;
            enum.filenameString = filenameString;
        end
    end
    
end

