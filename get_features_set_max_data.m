function [features_set] = get_features_set_max_data(sDirName, required_features_group_names)

    % Get all contents of csv files
    files_struct = dir([sDirName '\*.csv']);            
    
    max_num_examples = 0;
    
    for i = 1 : size(files_struct, 1)
        % Read the contents of the csv.
        % Skip the first header row
        f = csvread([sDirName '\' files_struct(i).name], 1);
        
        
        % Get the header, this is the candidate set
        fid = fopen([sDirName '\' files_struct(i).name]);
        header = fgetl(fid);
        fclose(fid);
        split_header = textscan(header,'%s','delimiter',',');
        
        % Get the candidate set by matching the pattern of the group name
        % in the header
        candidate_indices = [];
        for param_group_idx = 1 : size(required_features_group_names)
            found_indices = strfind(split_header{1}, required_features_group_names{param_group_idx});
            for idx = 1 : size(found_indices)
                if(found_indices{idx} == 1)
                    candidate_indices = [candidate_indices idx];
                end
            end
        end
        candidate_set = split_header{1}(candidate_indices);
        
        % The number of examples in this candidate set is initially the
        % number of examples in its file
        num_examples_in_candidate_set = size(f, 1);
        
        % Search in all other files for the same set, and add the found
        % number of examples
        rem_files_struct = [files_struct(1:i-1); files_struct(i+1:end)];
        num_examples_in_candidate_set = num_examples_in_candidate_set + search_candidate_set_in_files(sDirName, rem_files_struct, candidate_set);
        
        % Construct
        if(num_examples_in_candidate_set > max_num_examples)
            features_set = candidate_set;
            max_num_examples = num_examples_in_candidate_set;
        end
    end
end