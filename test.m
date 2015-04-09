       % Perform sequential feature selection for CLASSIFY on iris data with
       % noisy features and see which non-noise features are important
       load('fisheriris');
       %X = randn(150,10);
       %X(:,[1 3 5 7 ])= meas;
       X = meas;
       %X = [meas(:,1), meas(:,2)];
       y = nominal(ismember(species,'setosa'));
       
       pos_class ='true';
       %svmStruct = svmtrain(X,y,'showplot',false, 'method', 'LS', 'kernel_function', 'rbf');
       %svmStruct = svmtrain(X,y,'showplot',false,'kernel_function', 'rbf');
       svmStruct = svmtrain(X,y,'showplot',false);
       opt = statset('display','iter');
       % Generating a stratified partition is usually preferred to
       % evaluate classification algorithms.
       cvp = cvpartition(y,'k',10); 
       %[fs,history] = sequentialfs(@classf_1,X,y,'cv',cvp,'options',opt);
       [fs,history] = sequentialfs(@classf_svm,X,y,'cv',cvp,'options',opt);
       fs
       history
  

