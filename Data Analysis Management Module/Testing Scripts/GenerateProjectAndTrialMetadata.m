trial1 = Trial;

trial1.dirName = '';        
trial1.title = 'Human';
trial1.description = 'Human trial for AD research';
trial1.trialNumber = 1;
trial1.subjects = {};
trial1.subjectIndex = 0;        
trial1.subjectType = SubjectTypes.Human;      
trial1.notes = 'Human trial notes';


trial2 = Trial;

trial2.dirName = '';        
trial2.title = 'Dog';
trial2.description = 'Dog trial for AD research';
trial2.trialNumber = 2;
trial2.subjects = {};
trial2.subjectIndex = 0;        
trial2.subjectType = SubjectTypes.Dog;      
trial2.notes = 'Dog trial notes';


project = Project;

project.title = 'AD Research Project';
project.description = 'Diagnosing AD with polarimetry';
project.trials = {};
project.trialIndex = 0;
project.notes = 'Project notes';


% save metadata

metadata = trial1;

save('trial1.mat', 'metadata');

metadata = trial2;

save('trial2.mat', 'metadata');

metadata = project;

save('project.mat', 'metadata');