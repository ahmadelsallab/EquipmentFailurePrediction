function [mFeatures, mTargets] = ReadData(sDirName, nHorizon)
    
    % Get all contents of csv files
    % files_struct = dir('.\Input\*.csv');
    %files_struct = dir([sDirName '\*.csv']);
    files_struct = dir([sDirName '\0.csv']);
    
    mFeatures = [];
    mTargets = [];
    mLabelColomn = [];
    
    required_params_names = {'APUN1'; 'APUN2'; 'APUCYCNB'; 'APUFF'; 'APUHR'; 'APUP1'; 'IGV'; 'SCV'; 'APUOIT'; 'APUIT'; 'APUDCM'; 'APUEGTC'; 'APUDP';};
    
    for i = 1 : size(files_struct, 1)
        % Read the contents of the csv.
        % Skip the first header row
        f = csvread([sDirName '\' files_struct(i).name], 1);
        
        fprintf(1, '%d. Reading file %s...\n', i, files_struct(i).name);
        
        % Get header line
        fid = fopen([sDirName '\' files_struct(i).name]);
        header = fgetl(fid);
        split_header = textscan(header,'%s','delimiter',',');        
        % Loop on all the header entries, when the required parameter is
        % part of the header entry, add this index, else continue
        params_to_keep = [];
        for param_idx = 1 : size(required_params_names, 1)
            for m = 2 : size(split_header{1})
                if(size(strfind(split_header{1}{m}, required_params_names{param_idx}), 1) > 0)
                    % Match
                    params_to_keep = [params_to_keep m-1];
                end
            end
        end
        
        fclose(fid);
        % Data: skip first colomn (time stamp, see the same email)
        features_file = f(:, 2:end - 2);
        
        % Keep only the important parameters (see the same email)
%         APUEGT: 22-28
%         APUN1
%         APUN2
%         APUCYCNB
%         APUFF
%         APUHR
%         APUP1
%         IGV
%         SCV
%         APUOIT
%         APUIT
%         APUDCM
%         APUEGTC
%         APUDP
% params_to_keep = [5        %APUCYCNB
%                   6:8      %APUDCM
%                   13:17    %APUDP 
%                   22:28    %APUEGTC
%                   29:33    %APUFF
%                   55       %APUHR
%                   56:62    %APUIT
%                   63:69    %APUN1
%                   70:76    %APUN2
%                   77:83    %APUOIT
%                   84:88    %APUP1                        
%                   ];
        %params_to_keep = [5 6:8 13:17 22:28 29:33 55 56:62 63:69 70:76 77:83 84:88];
        
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
        % Append to total labels and features
        mFeatures = [mFeatures; features_after_mean];
        
        
        % Labels at colomn 178 = 4962W010. See email: "Fwd:
        % [GURUMSG-9MQLSSRZ1C01YPS2] (Do Not Modify) From: AI Tech", 6
        % April
        targets_file = f(:,end - 1);
        targets_before_mean = targets_file(1 : (size(targets_file, 1) - nHorizon), :);
        
        % The raw colomn labels
        mLabelColomn = [mLabelColomn; targets_file];
        
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
    
    save('processed_data.mat', 'mFeatures', 'mTargets');
end