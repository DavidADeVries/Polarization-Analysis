function [ ] = stat_test_result_print( value, file_id )
% need to be able to deal with NaN that pop up

if isnan(value)
    fprintf(file_id, ',NaN, ,');
else
    fprintf(file_id, ',%6.4f, ,', value);
end

end

