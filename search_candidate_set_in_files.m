function [number_examples] = search_candidate_set_in_files(sDirName, files_struct, candidate_set)

    number_examples = 0;
    for i = 1 : size(files_struct, 1)
        % Read the contents of the csv.
        % Skip the first header row
        f = csvread([sDirName '\' files_struct(i).name], 1);
                
        % Get the header, this is the candidate set
        fid = fopen([sDirName '\' files_struct(i).name]);
        header = fgetl(fid);
        fclose(fid);
        split_header = textscan(header,'%s','delimiter',',');
        % Check if the file contains the same features set
        [features_set_indices] = get_features_set_indices(split_header{1}, candidate_set);
        
        if(size(features_set_indices) > 0)
            number_examples = number_examples + size(f, 1);
        end
    end
end