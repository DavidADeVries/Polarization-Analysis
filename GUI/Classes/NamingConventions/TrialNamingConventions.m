classdef TrialNamingConventions
    %TrialNamingConventions
    
    properties (Constant)
        DIR_PREFIX = 'Trial';
        METADATA_FILENAME = 'trial_metadata.mat';
        %DATA_FILENAME_LABEL = ''; % we're not concerned about files from different trials getting all mixed up, so trial number will not be included in data filenames
    end
    
end

