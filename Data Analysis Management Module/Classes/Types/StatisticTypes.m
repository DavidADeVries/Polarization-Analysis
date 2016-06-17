classdef StatisticTypes
    % StatisticTypes
    
    properties
        displayString
    end
    
    enumeration
        mean     ('Mean')
        median   ('Median');
        stdev    ('Standard Deviation');
        skewness ('Skewness');
    end
    
    methods
        function enum = StatisticTypes(string)
            enum.displayString = string;
        end
    end
    
end

