function [M_G, M_A] = getGeneratorAndAnalyzerMatrices(mmComputationType)
% getGeneratorAndAnalyzerMatrices

if mmComputationType == chrisFranProgram
    [M_G, M_A] = getMatrices_ChrisFran();
elseif mmComputationType == davidProgram
    [M_G, M_A] = getMatrices_David();    
elseif mmComputationType == frankProgram
    [M_G, M_A] = getMatrices_Frank(); % THIS IS THE RIGHT ONE!!!    
end

end

