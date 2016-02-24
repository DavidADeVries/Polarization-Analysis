classdef SessionTypes
    %SessionTypes
    
    properties
        displayString
        sessionClass
    end
    
    enumeration
        % Data Collection
        Microscope                  ('Microscope Imaging Session',              MicroscopeSession.empty)
        CSLO                        ('CSLO Imaging Session',                    CSLOSession.empty) 
        
        % Data Processing
        LegacyRegistration          ('Legacy Registration Session',             LegacyRegistrationSession.empty)
        LegacySubsectionSelection   ('Legacy Subsection Selection Session',     LegacySubsectionSelectionSession.empty)
        FrameAveraging              ('Frame Averaging Session',                 FrameAveragingSession.empty)
        Registration                ('Registration Session',                    RegistrationSession.empty)
        PolarizationAnalysis        ('Polarization Analysis Session',           PolarizationAnalysisSession.empty)
        
    end
    
    methods
        function enum = SessionTypes(string, class)
            enum.displayString = string;
            enum.sessionClass = class;
        end
    end
    
end

