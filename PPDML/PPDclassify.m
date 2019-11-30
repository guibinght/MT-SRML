 function accuracy=PPDclassify(model,Xtrain,Xtest,Ytrain,Ytest,chit)
% function
% [predictLabels,accuracy]=dpesvmpredict(model,Xtrain,Xtest,Ytrain
% ,Ytest,k)
% Classify the testing set using k-NN strategy, based on Mahalanobis 
% distance trained by doublet-SVM, and obtain the recognition accuracy of the
% testing set.
%
% Input:
%
% model    the SVM model trained by 'svmtraintime' function
% Xtrain   the training set (each column is a training sample)
% Xtest    the testing set (each column is a testing sample)
% Ytrain   the labels of training samples
% Ytest    the labels of testing samples
% k        the number of nearest neighbors in k-NN strategy (usually equal to chit)
%
% Output:
% accuracy the recognition accuracy (%) of testing set

[nSV,dim]=size(model.SVs);
dim=dim/2;
SVs=model.SVs';
M=zeros(dim,dim);
for i=1:nSV
    M=M+model.sv_coef(i)*(SVs(1:dim,i)-SVs(dim+(1:dim),i))*(SVs(1:dim,i)-SVs(dim+(1:dim),i))';
end
M=PosCone(M);
testSampleNum=size(Xtest,2);
trainSampleNum=size(Xtrain,2);
predictLabels=zeros(size(Ytest));

% M=eye(dim);
for i=1:testSampleNum
    dist=zeros(1,trainSampleNum);
    for j=1:trainSampleNum
        dist(j)=(Xtest(:,i)-Xtrain(:,j))'*M*(Xtest(:,i)-Xtrain(:,j));
    end
    [~,minindex]=mink(dist(:),chit);
    predictLabels(i)=mode(Ytrain(minindex));

end
correctNum=length(find(predictLabels==Ytest));
accuracy=correctNum/testSampleNum*100;
disp(strcat('recognition accuracy:',num2str(accuracy)));
end