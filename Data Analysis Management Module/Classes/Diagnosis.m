classdef Diagnosis
    % Diagnosis
    
    properties
        diagnosisType
        diagnosisLevel
        isPrimaryDiagnosis
    end
    
    methods
        
        function diagnosis = Diagnosis(diagnosisType, diagnosisLevel, isPrimaryDiagnosis)
            diagnosis.diagnosisType = diagnosisType;
            diagnosis.diagnosisLevel = diagnosisLevel;
            diagnosis.isPrimaryDiagnosis = isPrimaryDiagnosis;
        end
        
        function string = getString(diagnosis)
            string = [diagnosis.diagnosisType.displayString, ' (', diagnosis.diagnosisLevel.displayString, ')'];
            
            if diagnosis.isPrimaryDiagnosis
                string = [string, '*'];
            end
        end
        
    end
    
end

