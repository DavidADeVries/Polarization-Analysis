classdef Diagnosis
    % Diagnosis
    
    properties
        diagnosisType = [];
        diagnosisLevel = [];
        isPrimaryDiagnosis = false;
    end
    
    methods
        
        function diagnosis = Diagnosis(diagnosisType, diagnosisLevel, isPrimaryDiagnosis)
            if nargin > 0
                diagnosis.diagnosisType = diagnosisType;
                diagnosis.diagnosisLevel = diagnosisLevel;
                diagnosis.isPrimaryDiagnosis = isPrimaryDiagnosis;
            end
        end
        
        function string = getDisplayString(diagnosis)
            string = [diagnosis.diagnosisType.displayString, ' [', diagnosis.diagnosisLevel.displayString, ']'];
            
            if diagnosis.isPrimaryDiagnosis
                string = [string, '*'];
            end
        end
        
    end
    
end

