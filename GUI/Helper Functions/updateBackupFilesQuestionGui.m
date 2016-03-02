function updateBackupFiles = updateBackupFilesQuestionGui()
% updateBackupFilesQuestionGui

prompt = 'Would you like to apply changes to back-up files as well? Please use with care! Changes to back-up data should only be done to correct for import mistakes.';
title = 'Change Back-up Files?';

yes = 'Yes';
no = 'No';

button = questdlg(prompt, title, yes, no, yes);

updateBackupFiles = strcmp(button, yes);


end

