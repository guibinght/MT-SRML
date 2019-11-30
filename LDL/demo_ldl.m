dataname{1}='Natural_Scene.mat';
acc_mean=zeros(1,6);
acc_std=zeros(1,6);
for chit=5
dtype=3;
lambda=0.01;
%method='dml';krr
method='dml';

for i=1
    dataname{i}
    chit
  eval(['load ' dataname{i}]) ;
  [acc_mean,acc_std]=crossvalidation(features,labels,method,chit,dtype,lambda)
  acc_mean'
  acc_std'
end
end


