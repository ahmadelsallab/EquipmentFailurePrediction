function [features_set_indices] = get_features_set_indices(split_header, features_set)
    % Get the parameters indices of the important params in this
    % file
    features_set_indices = [];
    for param_idx = 1 : size(features_set, 1)
        % Search for the required param group name in the header
        found_index = find(strcmp(split_header, features_set(param_idx,:)) == 1);
        
        if(~isempty(found_index))
            features_set_indices = [features_set_indices found_index];
        else
            % If any feature is not found, return an empty list
            features_set_indices = [];
            break;
        end

    end
end

