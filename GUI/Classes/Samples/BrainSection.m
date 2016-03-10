classdef BrainSection < FixedSample
    %BrainSection
    
    properties
        sectionAnatomy = ''; %the anatomy of where the brain section is from
        brainSectionNumber
    end
    
    methods
        
        function section = BrainSection(sampleNumber, existingSampleNumbers, brainSectionNumber, existingBrainSectionNumbers, toSubjectPath, projectPath, importPath, userName)
            [cancel, section] = section.enterMetadata(sampleNumber, existingSampleNumbers, brainSectionNumber, existingBrainSectionNumbers, importPath, userName);
            
            if ~cancel
                % set UUID
                section.uuid = generateUUID();
                
                % set navigation listbox label        
                section.naviListboxLabel = section.generateListboxLabel();
                
                % make directory/metadata file
                section = section.createDirectories(toSubjectPath, projectPath);
                
                % set metadata history
                section.metadataHistory = {MetadataHistoryEntry(userName, section)};
                
                % save metadata
                saveToBackup = true;
                section.saveMetadata(makePath(toSubjectPath, section.dirName), projectPath, saveToBackup);
            else
                section = BrainSection.empty;
            end              
        end
        
        function [cancel, section] = enterMetadata(section, suggestedSampleNumber, existingSampleNumbers, suggestedBrainSectionNumber, existingBrainSectionNumbers, importPath, userName)
            
            %Call to BrainSectionMetadataEntry GUI
            [...
                cancel,...
                sampleNumber,...
                brainSectionNumber,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                storageLocation,...
                anatomy,...
                initFixative,...
                initPercent,...
                initTime,...
                secondFixative,...
                secondPercent,...
                secondTime]...
                = BrainSectionMetadataEntry(suggestedSampleNumber, existingSampleNumbers, suggestedBrainSectionNumber, existingBrainSectionNumbers, userName, importPath);
            
            if ~cancel
                %Assigning values to Brain Section Properties
                section.sampleNumber = sampleNumber;
                section.brainSectionNumber = brainSectionNumber;
                section.source = source;
                section.timeOfRemoval = timeOfRemoval;
                section.timeOfProcessing = timeOfProcessing;
                section.dateReceived = dateReceived;
                section.storageLocation = storageLocation;
                section.sectionAnatomy = anatomy;
                section.initialFixative = initFixative;
                section.initialFixativePercent = initPercent;
                section.initialFixingTime = initTime;
                section.secondaryFixative = secondFixative;
                section.secondaryFixativePercent = secondPercent;
                section.secondaryFixativeTime = secondTime;
            end
        end
                
        function section = loadObject(section, sectionPath)
        end
        
    end
    
end

