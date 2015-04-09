clear, clc, close all;


sDirName = '.\Input';

% Horizon of prediction future points
nHorizons = [3 5];


    
for nHorizonIdx = 1 : length(nHorizons)
    nHorizon = nHorizons(nHorizonIdx);
    fprintf(1, 'Trying nHorizon = %d...\n', nHorizons(nHorizonIdx));
    
    % Preprocessing
    if (~exist(['processed_data_horizon_' num2str(nHorizon) '.mat'], 'file'))
        [mFeatures, mTargets, features_set] = ReadData(sDirName, nHorizon); 
        save(['processed_data_horizon_' num2str(nHorizon) '.mat']);
    else
        load(['processed_data_horizon_' num2str(nHorizon) '.mat']);
    end
    
    % Features selection SVM    
    X = mFeatures;

    % Number of reduced dim
    %nDim = floor(size(mFeatures, 2) * (1 - nDimReductionPercent));
    nDim = 5;
    %nDim = floor(size(mFeatures, 2));

    y = mTargets;
    opt = statset('display','iter');
    % Generating a stratified partition is usually preferred to
    % evaluate classification algorithms.
    cvp = cvpartition(y,'k',2); 
    %cvp = cvpartition(y,'Leaveout'); 
    [fs,history] = sequentialfs(@classf,X,y,'NFeatures', nDim, 'cv',cvp,'options',opt);

    %save 'features_selection_model';
    save(['features_selection_model_' num2str(nHorizon) '.mat']);
    
    % ROC curves and F1 score
    bPlot = 1;
    for nDim = 1 : size(history.In, 1)
        fs = history.In(nDim, :);
        figure;
        [errRate, AUC, F1, pr, re] = calc_performance(mFeatures, mTargets, fs, features_set, nDim, nHorizon, bPlot)
    end
    
end



