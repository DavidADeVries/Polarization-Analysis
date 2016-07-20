function xls_delete_sheets(xlsfile,sheets)
% 
% Delete worksheets in Excel file
% 
% 
%USAGE
%-----
% xls_delete_sheets(xlsfile)
% xls_delete_sheets(xlsfile,sheets)
% 
% 
%INPUT
%-----
% - XLSFILE: name of the Excel file
% - SHEETS : cell array with the worksheet names, or matrix with positive
%   integers to tell which worksheets are going to be protected. If
%   SHEETS=[], all empty sheets will be deleted.
% 
% 
%OUTPUT
%------
% - XLSFILE will be edited
% 
% 
% Based on "How do I delete worksheets in my Excel file using MATLAB?"
% (http://www.mathworks.com/support/solutions/en/data/1-21EPB4/index.html?solution=1-21EPB4)
% 
% 
% See also XLS_CHECK_IF_OPEN
% 

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2012-Dec-30, 05:29 pm


% Input
%==========================================================================
if exist(xlsfile,'file')~=2
    fprintf('%s not found.\n',xlsfile)
    return
end
if nargin<2
    sheets = [];
end


% Close Excel file
%-----------------
tmp = xls_check_if_open(xlsfile,'close');
if tmp~=0 && tmp~=10
    %fprintf('%s could not be closed.\n',xlsfile)
    return
end


% The full path is required for the command "workbooks.Open" to work
% properly
%-------------------------------------------------------------------
if isempty(strfind(xlsfile,filesep))
    xlsfile = fullfile(pwd,xlsfile);
end


% Read Excel file
%==========================================================================
%[type,sheet_names] = xlsfinfo(xlsfile);      % get information returned by XLSINFO on the workbook
Excel      = actxserver('Excel.Application'); % open Excel as a COM Automation server
set(Excel,'Visible',0);                       % make the application invisible
 % or ExcelApp.Visible = 0;
set(Excel,'DisplayAlerts',0);                 % make Excel not display alerts (e.g., sound and confirmation)
 % or Excel.Application.DisplayAlerts = false; % or 0
Workbooks  = Excel.Workbooks;                 % get a handle to Excel's Workbooks
Workbook   = Workbooks.Open(xlsfile);         % open an Excel Workbook and activate it
Sheets     = Excel.ActiveWorkBook.Sheets;     % get the sheets in the active Workbook
num_sheets = Sheets.Count;                    % number of worksheets
num_sheets_orig = num_sheets;


% Get sheets to delete
%==========================================================================
if ischar(sheets)
    sheets = {sheets};
end
if iscell(sheets)
    sheetidx = 1:length(sheets);
elseif isnumeric(sheets) && ~isempty(sheets) && ...
        isvector(sheets)==1 && all(floor(sheets)==ceil(sheets))
    sheetidx = sort(sheets,'descend');  % it is easier to go backwards
    sheetidx(sheetidx<1) = [];          % minimum sheet index is 1
    sheetidx(sheetidx>num_sheets) = []; % maximum sheet index is num_sheets
elseif isnumeric(sheets) && isempty(sheets)
    % sheets = [];
else
   % disp('Invalid input for SHEETS.')
    xls_save_and_close
    return
end


% Delete sheets
%==========================================================================
try

if ~isempty(sheets)
     
    % Delete selected worksheets
    %----------------------------
    for ss=sheetidx
        
        if num_sheets>1 % there must be at least 1 sheet
            
            if iscell(sheets)
                invoke(get(Sheets,'Item',sheets{ss}),'Delete')
            else
                invoke(get(Sheets,'Item',ss),'Delete')
                %Sheets.Item(ss).Delete;
            end
            num_sheets = num_sheets - 1;
            
        else
            if iscell(sheets)
                tmp = sheets{ss};
                if ~strcmp(tmp,Sheets.Item(1).Name) % sheet does not exist
                    break
                end
            else
                tmp = Sheets.Item(1).Name;
            end
            %fprintf('%s will not be deleted. There must be at least 1 worksheet.\n',tmp)
            break
        end
        
    end
    
else
    
    % Delete the empty worksheets
    %----------------------------
    
    % Loop over sheets
    for ss=num_sheets:-1:1 % it is easier to go backwards
        %if Excel.WorksheetFunction.CountA(Sheets.Item(ss).Cells)==0
        % count the number of non-empty cells
        % COUNTA applies to Excel 2013, 2011 for Mac, 2010, 2007, 2003, XP, 2000
        if Sheets.Item(ss).UsedRange.Count == 1 && ...
                strcmp(Sheets.Item(ss).UsedRange.Rows.Address,'$A$1') && ...
                isnan(Sheets.Item(ss).Range('A1').Value)
        % If the sheet is empty or contains 1 non-empty cell,
        % UsedRange.Count=1. So the three conditions above check if the
        % sheet is really empty (there is nothing even in the first cell).
            if num_sheets>1
                Sheets.Item(ss).Delete;
                num_sheets = num_sheets - 1;
            else
                %fprintf('%s will not be deleted. There must be at least 1 worksheet.\n',Sheets.Item(1).Name)
            end
        end
    end
    
end

catch ME
    disp(ME.message)
end

xls_save_and_close

if num_sheets_orig>num_sheets
    if num_sheets_orig-num_sheets>1
       % fprintf('%d worksheets were deleted.\n',num_sheets_orig-num_sheets)
    else
        %fprintf('1 worksheet was deleted.\n')
    end
else
    %disp('Nothing was done.')
end


% Save and close
%==========================================================================
function xls_save_and_close
    Workbook.Save;   % save the workbook
    Workbooks.Close; % close the workbook
    Excel.Quit;      % quit Excel
    % or invoke(Excel,'Quit');
    delete(Excel);   % delete the handle to the ActiveX Object
    clear Excel Workbooks Workbook Sheets
end

end