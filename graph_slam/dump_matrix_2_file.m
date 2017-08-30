function dump_matrix_2_file(fname, m)
%
% David Z, Feb 19, 2015 
% try to construct a function to dump every kind of matrix into a text file
%

dump_matrix_2_file_wf(fname, m)

end

function dump_matrix_2_file_wf(f, m)
    f_id = fopen(f, 'w+');
    for i=1:size(m,1)
        fprintf(f_id, '%f ', m(i,:));
        fprintf(f_id, '\n');
    end
    fclose(f_id);
end