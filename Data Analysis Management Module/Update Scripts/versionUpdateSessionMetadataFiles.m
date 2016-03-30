function [] = versionUpdateSessionMetadataFiles(projectPath, toPath)
%updateSession

% ** READ IN METADATA FILE **

% vars = load(makePath(projectPath, toPath, 'session_metadata.mat'), Constants.METADATA_VAR);
% metadata = vars.metadata;
% 
% if isa(metadata, 'MicroscopeSession')
%     % ** UPDATE REQUIRED INFORMATION **
%     
%     metadata.bwPixelSizeMicrons = 0.16; 
%     metadata.rgbPixelSizeMicrons = 0.17;
%     
%     % ** SAVE IT **
%     
%     metadataFilename = SessionNamingConventions.METADATA_FILENAME;
%     saveToBackup = true;
%     
%     saveObjectMetadata(metadata, projectPath, toPath, metadataFilename, saveToBackup);
% end




end


