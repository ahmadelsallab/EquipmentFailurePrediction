function [errRate, AUC, F1, pr, re] = calc_performance_train_test(mTrainFeatures, mTrainTargets, mTestFeatures, mTestTargets, fs, features_set, nDim, nHorizon, bPlot)

% ROC curve
x = mTrainFeatures(:, fs);
y = mTrainTargets;

svmStruct = svmtrain(x,y,'showplot',true);

% SVM classify: svmclassify has to be modified as follows:
%function [outclass, p] = svmclassify(svmStruct,sample, varargin)
%[outclass, p] = svmdecision(sample,svmStruct);

x = mTestFeatures(:, fs);
y = mTestTargets;
[C, p] = svmclassify(svmStruct,mTrainFeatures(:, fs);,'showplot',true);
%p = -p;% flip the sign to get the score for the +1 class
errRate = sum(y~= C)/size(x, 1)  %mis-classification rate
conMat = confusionmat(y,C) % the confusion matrix

%[X,Y] = perfcurve(species(51:end,:),p,'virginica');
[X_perf,Y_perf, T, AUC] = perfcurve(y,p,1);
AUC
if(bPlot > 0)
    plot(X_perf,Y_perf)
    xlabel('False positive rate'); ylabel('True positive rate')
    title(['ROC for classification by SVM Features: ' cell2str(features_set(fs))])
end

% Calculate precision
pr = conMat(2,2)/(conMat(2,1) + conMat(2,2));

% Calculate recall
re = conMat(2,2)/(conMat(1,2) + conMat(2,2));

% Calculate F1 score
F1 = 2 * (pr*re)/(pr+re);

if(isnan(F1))
    F1 = 0;
end

if(bPlot > 0)
    saveas(gcf, ['ROC_Dimension_' num2str(nDim) '_Horizon_' num2str(nHorizon) '_AUC_' num2str(AUC) '_F1_' num2str(F1) '.fig'], 'fig');
end

end