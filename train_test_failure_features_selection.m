clear, clc, close all;
% Perform sequential feature selection for CLASSIFY on iris data with
% noisy features and see which non-noise features are important

% Preprocessing

%load('fisheriris');
sDirName = '.\Input';

% Horizon of prediction future points
nHorizons = [1 20 30];

% Number of reduced dim
%nDimReductionPercent = 0.25;
if (~exist('processed_data.mat','file'))
    [mFeatures, mTargets, features_set] = ReadData(sDirName, nHorizon);
    
else
    load processed_data;
end
    
for nHorizonIdx = 1 : length(nHorizons)
    nHorizon = nHorizons(nHorizonIdx);

    
    % Features selection SVM
    %X = randn(150,10);
    X = mFeatures;

    % Number of reduced dim
    %nDim = floor(size(mFeatures, 2) * (1 - nDimReductionPercent));
    %nDim = 2;
    nDim = floor(size(mFeatures, 2));

    y = mTargets;
    opt = statset('display','iter');
    % Generating a stratified partition is usually preferred to
    % evaluate classification algorithms.
    cvp = cvpartition(y,'k',2); 
    %cvp = cvpartition(y,'Leaveout'); 
    [fs,history] = sequentialfs(@classf,X,y,'NFeatures', nDim, 'cv',cvp,'options',opt);

    save 'features_selection_model';
    
    % ROC curves and F1 score
    bPlot = 1;
    for nDim = 1 : size(history.In, 1)
        fs = history.In(nDim, :);
        figure;
        [errRate, AUC, F1, pr, re] = calc_performance(mFeatures, mTargets, fs, features_set, nDim, nHorizon, bPlot)
    end
    
end



