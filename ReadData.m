function [mFeatures, mTargets, features_set] = ReadData(sDirName, nHorizon)
    
    % Get all contents of csv files
    % files_struct = dir('.\Input\*.csv');
    %files_struct = dir([sDirName '\*.csv']);
    files_struct = dir([sDirName '\*.csv']);
    
    mFeatures = [];
    mTargets = [];
    mLabelColomn = [];
    
    label_col_name = ['Failure_4962W010';];
    required_params_names = {'APUN1'; 'APUN2'; 'APUCYCNB'; 'APUFF'; 'APUHR'; 'APUP1'; 'IGV'; 'SCV'; 'APUOIT'; 'APUIT'; 'APUDCM'; 'APUEGTC'; 'APUDP';};
    % Get the features set that has the max number of examples
    [features_set] = get_features_set_max_data(sDirName, required_params_names);
    
    % Now append the files with colomns that have at least the features_set
    for i = 1 : size(files_struct, 1)
        % Read the contents of the csv.
        % Skip the first header row
        f = csvread([sDirName '\' files_struct(i).name], 1);
        
        fprintf(1, '%d. Reading file %s...\n', i, files_struct(i).name);
        
        % Get header line
        fid = fopen([sDirName '\' files_struct(i).name]);
        header = fgetl(fid);
        fclose(fid);
        split_header = textscan(header,'%s','delimiter',',');        
        % Loop on all the header entries, when the required parameter is
        % part of the header entry, add this index, else continue
        params_to_keep = get_features_set_indices(split_header{1}, features_set);
        
        % If the file doesn't contain any of the features_set params, then
        % it is skipped completeted
        
        % Labels at colomn 178 = 4962W010. See email: "Fwd:
        % [GURUMSG-9MQLSSRZ1C01YPS2] (Do Not Modify) From: AI Tech", 6
        % April
        [label_index] = get_features_set_indices(split_header{1}, label_col_name);
        
        if(isempty(params_to_keep) || (size(label_index, 2) == 0))
            continue;
        end
        
        % Data: skip first colomn (time stamp, see the same email)
        features_file = f;        
        
        % Also, the last nHorizon rows have no associated labels, since the data at time T+n does not exist, so no need
        % to keep them

        features_before_mean = features_file(1: (size(features_file, 1) - nHorizon), params_to_keep);
        %features_before_mean = features_file(1: (size(features_file, 1) - nHorizon), :); % NOT ALL FILES HAVE THE SAME PARAMETERS, so insertion is inconsistent over all files
        
        % We make expectation from the features at T and T-1, so we average
        % the current and previous rows to get collective values
        features_after_mean = [];
        for j = 1 : size(features_before_mean, 1) - 1
            f_collective = [features_before_mean(j, :); features_before_mean(j + 1, :)];
            f_mean = mean(f_collective, 1);
            features_after_mean = [features_after_mean; f_mean];
        end

        
        
   
        targets_file = f(:,label_index(1));
        targets_before_mean = targets_file(1 : (size(targets_file, 1) - nHorizon), :);
        
        % The raw colomn labels
        mLabelColomn = [mLabelColomn; targets_file];
        
        % Append to total labels and features
        mFeatures = [mFeatures; features_after_mean];
        
        % Every two time
        % stamps (T, T-1) merge to 1 instance. So the label of (1,2) is the
        % label at (2 + n) = (i(range = 2:length - nHorizon - 1) + nHorizon)
        % We stop at (size(features_file, 1) - nHorizon - 1)
        targets_after_mean = [];
        for j = 1 : size(targets_before_mean, 1) - 1

            targets_after_mean = [targets_after_mean; targets_file(j + 1 + nHorizon, :)];

        end
        
        mTargets = [mTargets; targets_after_mean];
        
        fprintf(1, 'Finished reading file\n');
    end
    
    save('processed_data.mat', 'mFeatures', 'mTargets', 'features_set');
    features_set
end