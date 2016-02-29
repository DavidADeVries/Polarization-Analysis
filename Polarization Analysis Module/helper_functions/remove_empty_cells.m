function [ cleaned_cell_array ] = remove_empty_cells( cell_array )

% count empty cells

num_empty_cells = 0;

for i=1:length(cell_array)
   if isempty(char(cell_array(i)))
       num_empty_cells = num_empty_cells + 1;
   end
end

cleaned_cell_array = cell(length(cell_array) - num_empty_cells,1);

j = 1; %counter for cleaned_array

for i=1:length(cell_array)
   if ~isempty(char(cell_array(i)))
       cleaned_cell_array(j) = cell_array(i);
       j = j+1;
   end
end

end

