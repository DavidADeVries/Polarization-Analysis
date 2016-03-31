classdef PolarizationAnalysisSession < DataProcessingSession
    % PolarizationAnalysisSession
    % stores metadata for a polarization analysis sessios
    
    properties
        muellerMatrixComputationType = []
        muellerMatrixNormalizationType = []
        muellerMatrixOnly
        versionNumber %compare to the Version.m versionNumber
    end
    
    methods
    end
    
end
