function [ path ] = makePath( varargin )
%makePath
%takes a series of directories and joins them up with a slash

slash = '\';

path = '';

for i=1:length(varargin)
    if i == 1
        path = varargin{i};
    else
        path = [path, slash, varargin{i}];
    end
end


end

