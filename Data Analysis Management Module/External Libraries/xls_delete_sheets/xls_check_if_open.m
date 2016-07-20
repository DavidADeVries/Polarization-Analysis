function isopen = xls_check_if_open(xlsfile,action)
% 
% Determine if Excel file is open. If it is open in MS Excel, it can be
% closed.
% 
% 
%USAGE
%-----
% isopen = xls_check_if_open(xlsfile)
% isopen = xls_check_if_open(xlsfile,action)
% 
% 
%INPUT
%-----
% - XLSFILE: name of the Excel file
% - ACTION : 'close' (closes file if it is open) or '' (do nothing)
%   Option 'close' only works with MS Excel.
% 
% 
%OUTPUT
%------
% - ISOPEN:
%   1  if XLSFILE is open
%   0  if XLSFILE is not open
%   10 if XLSFILE was closed
%   11 if XLSFILE is open and could not be closed
%   -1 if an error occurred
% 
% 
% Based on "How can I determine if an XLS-file is open in Microsoft Excel,
% without using DDE commands, using MATLAB 7.7 (R2008b)?"
% (www.mathworks.com/support/solutions/en/data/1-954SDY/index.html)
% 

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2012-Dec-30, 05:21 pm

isopen = -1;

% Input
%==========================================================================

if nargin<2
    action = '';
end

if exist(xlsfile,'file')~=2
    fprintf('%s not found.\n',xlsfile)
    return
end

% The full path is required because of "Workbooks.Item(ii).FullName"
if isempty(strfind(xlsfile,filesep))
    xlsfile = fullfile(pwd,xlsfile);
end

switch action
    case ''
        close = 0;
    case 'close'
        close = 1;
    otherwise
        disp('Unknown option for ACTION.')
        return
end


% 1) Using DDE commands
%==========================================================================
% isopen = ddeinit('Excel',excelfile);
% if isopen~=0
%     isopen = 1;
% end
% But now DDEINIT has been deprecated, so ignore this option.


% 2) Using ActiveX commands
%==========================================================================
if close
    try
        
        % Check if an Excel server is running
        %------------------------------------
        Excel = actxGetRunningServer('Excel.Application');
        
        isopen = 0;
        
        Workbooks = Excel.Workbooks; % get the names of all open Excel files
        for ii = 1:Workbooks.Count
            if strcmp(xlsfile,Workbooks.Item(ii).FullName)
                isopen = 11;
                Workbooks.Item(ii).Save % save changes
                %Workbooks.Item(ii).SaveAs(filename) % save changes with a different file name
                %Workbooks.Item(ii).Saved = 1; % if you don't want to save
                Workbooks.Item(ii).Close; % close the Excel file
                isopen = 10;
                break
            end
        end
        
    catch ME
        % If Excel is not running, "actxGetRunningServer" will result in error
        if ~strcmp(ME.identifier,'MATLAB:COM:norunningserver')
            disp(ME.message)
            close = 0; % => use FOPEN
        else
            isopen = 0;
        end
    end
    
end
    
    
% 3) Using FOPEN
%==========================================================================
if ~close
    if exist(xlsfile,'file')==2 % if xlsfile does not exist, it will be created by FOPEN
        fid = fopen(xlsfile,'a');
        if fid==-1 % MATLAB is unable to open the file
            if strcmp(action,'close') % asked to close but an error occurred
                isopen = 11;
            else
                isopen = 1;
            end
        else
            isopen = 0;
            fclose(fid);
        end
    end
end