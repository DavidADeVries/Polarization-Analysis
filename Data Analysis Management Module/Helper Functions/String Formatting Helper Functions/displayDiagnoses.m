function diagnosesStrings = displayDiagnoses(diagnoses)
% displayDiagnoses

diagnosesStrings = {};

for i=1:length(diagnoses)
    diagnosesStrings = [diagnosesStrings, {diagnoses{i}.getDisplayString()}];
end


end

