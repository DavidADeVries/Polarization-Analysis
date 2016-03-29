function [] = setDiagnosesListbox(diagnosesListboxHandle, diagnoses)
% setDiagnosesListbox

numDiagnoses = length(diagnoses);

if numDiagnoses == 0
    selections = {'No Diagnoses'};
    selectionValue = 1;
else
    selections = {};
    
    for i=1:numDiagnoses
        selections = [selections, diagnoses{i}.getDisplayString()];
    end
    
    selectionValue = 1;
end

set(diagnosesListboxHandle, 'String', selections, 'Value', selectionValue);


end

