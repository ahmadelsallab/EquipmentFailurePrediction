% Parameters:
%%%%%%%%%%%%%

% Number of reduced dim
nDim = 100;

% Horizon of prediction future points
nHorizon = 1;

% Permitted samples within which prediction is correct
cClearance = 20;

% Factor for random splitting the data into train and test sets
nTrainTestFactor = 0.1;

% SVM kernel
sSVMKernel = 'linear';

% Algorithm:
%%%%%%%%%%%%

% Data loading:
%-------------

    
    % 1.Load all csv's in one big data frame
    % Exclude first row (header) of each csv file
    
    
    % 2. Merge each the current and previous rows in one feature (T, T-1).
    % First data row of the big data frame is also skipped since no previous row to it (no T-1).
    % Also, drop the last nHorizon points since their predictions labels do
    % not exist in the current dataset.
    
    % Append last row as labels

% End loop

% PCA:
%----
% Normalize the data by zscore first
[res, mMappedData] = pcares(zscore(mFeatures), nDim);
    
% Labeling:
%----------

% Loop on L

% L(i) = uniq(L(i + nHorizon):L(i+ nHorizon + cClearance});

% Classification:
%----------------

% Split the data into train and test

% Split the cross validation data

% Train SVM, cross validation
svm = svmtrain(mTrainFeatures, mTrainTargets, 'kernel', sSVMKernel);
    
% Classify
mObtainedTargets = svmclassify(svm, mTestFeatures,'showplot',true);

%Mis-classification rate
errRate = sum(mTestTargets~= mObtainedTargets)/size(mTrainTargets, 2)

% Confusion matrix
conMat = confusionmat(mTestTargets, mObtainedTargets)

% Plot precision recall curves