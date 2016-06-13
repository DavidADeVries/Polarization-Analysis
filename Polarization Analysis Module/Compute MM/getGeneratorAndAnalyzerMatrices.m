function [M_G, M_A] = getGeneratorAndAnalyzerMatrices(mmComputationType)
% getGeneratorAndAnalyzerMatrices

if mmComputationType == MuellerMatrixComputationTypes.chrisFranProgram
    [M_G, M_A] = getMatrices_ChrisFran();
elseif mmComputationType == MuellerMatrixComputationTypes.davidProgram
    [M_G, M_A] = getMatrices_David();    
elseif mmComputationType == MuellerMatrixComputationTypes.frankProgram
    [M_G, M_A] = getMatrices_Frank(); % THIS IS THE RIGHT ONE!!!
elseif mmComputationType == MuellerMatrixComputationTypes.csloProgram
    [M_G, M_A] = getMatrices_CSLO();
else
    error('Invalid Computation Type');
end

end

