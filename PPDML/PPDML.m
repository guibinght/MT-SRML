function  accu=PPDML(tr_dat,tt_dat,trls,ttls,chit,cmiss)    
%Input:
%tr_dat  training set
%tt_dat  test set
%trls    training label
%ttls    test label
%chit    number of positive pair 
%cmiss   number of negative pair

%Output:
%accu    Classification accuracy

%get positive and negative sample pair
[zr,yr]=PPDpair(tr_dat,trls,chit,cmiss);
%metric learning
%[SVM_model,~]=svmtraintime(yr',zr','-s 4 -t 5 -n 0.1 -h 0 -f 1');
[SVM_model,~]=svmtraintime(yr',zr','-t 5 -h 0 -f 1');
%classification by the learned metric 
accu=PPDclassify(SVM_model,tr_dat,tt_dat,trls,ttls,chit);