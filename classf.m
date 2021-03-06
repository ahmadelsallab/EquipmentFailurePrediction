function err = classf(xtrain,ytrain,xtest,ytest)
 %yfit = classify(xtest,xtrain,ytrain,'quadratic');
 
 % Load the data and select features for classification
    %load fisheriris
    X = xtrain;
    % Extract the Setosa class
    Y = ytrain;
    opt = statset('MaxIter',Inf);
    % Use a linear support vector machine classifier
    %svmStruct = svmtrain(X,Y,'showplot',true);
    
    %"No convergence achieved within maximum number of iterations"
    %     Then do one or all of:
    % 
    % lower the box constraint
    % increase tolkkt
    % specify a positive value for kktviolationlevel
    % try a different kernel function
    %svmStruct = svmtrain(X,Y,'showplot',false,  'options', opt, 'kktviolationlevel', 5, 'tolkkt', 0.1);
    svmStruct = svmtrain(X,Y,'showplot',false,  'options', opt);
    
    %figure;
    %C = svmclassify(svmStruct,xtest,'showplot',true);
    [C, p] = svmclassify(svmStruct,xtest,'showplot',false);
    errRate = sum(ytest~= C)/size(ytest, 1);  %mis-classification rate
    conMat = confusionmat(ytest,C); % the confusion matrix
    yfit = C;
    [X_perf,Y_perf, T, AUC] = perfcurve(ytest,p,1);
    %err = sum(~strcmp(ytest,yfit));
    %err = errRate
    
    % Calculate precision
    pr = conMat(2,2)/(conMat(2,1) + conMat(2,2));

    % Calculate recall
    re = conMat(2,2)/(conMat(1,2) + conMat(2,2));

    % Calculate F1 score
    F1 = 2 * (pr*re)/(pr+re);
    
    if(isnan(F1))
        F1 = 0;
    end
    
    err = 1 - AUC