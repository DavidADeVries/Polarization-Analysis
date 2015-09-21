function [ ] = make_MM_output_folders( path )
%Creates the needed directories to output to

mkdir(path)

mkdir(strcat(path, '/CSVs'));
mkdir(strcat(path, '/Colour'));
mkdir(strcat(path, '/Greyscale'));
mkdir(strcat(path, '/Greyscale [No Scalebar] - Rescaled'));
mkdir(strcat(path, '/Greyscale [No Scalebar]'));
mkdir(strcat(path, '/Composites'));

end

