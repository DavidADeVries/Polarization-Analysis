classdef DiagnosisTypes
    %DiagnosisTypes
    
    properties
        displayString
        fullString
    end
    
    enumeration
        AD_Pos              ('AD Positive', 'Alzheimer''s Disease Postive')
        AD_Neg              ('AD Negative (Control)', 'Alzheimer''s Disease Negative')
        
        DLB                 ('DLB', 'Dementia with Lewy Bodies')
        CVD                 ('CVD', 'Cerebrovascular Disease')
        CAA                 ('CAA', 'Cerebral Amyloid Angiopathy')
        FTLD_TDP            ('FTLD-TDP', 'Frontotemporal Lobar Degeneration with TDP-immunoreactive Inclusions')
        PD                  ('PD', 'Unknown translation')
        
        CognitiveNormal     ('Cognitively Normal', 'Cognitively Normal');
        CognitiveImpair     ('Cognitively Impaired', 'Cognitively Impaired');        
        
        Unknown             ('Unknown', 'Unknown')
    end
    
    methods
        function enum = DiagnosisTypes(displayString, fullString)
            enum.displayString = displayString;
            enum.fullString = fullString;
        end
    end
    
end

