function [X_tr,Y_train,X_te,Y_test,zr,yr,V_num]=Data_Generation2


clear;
 
% ��һ������ԭʼ���ݲ��train��test

load('/dataset/football_6view.mat');
numclass = max(Y)-min(Y) + 1;
V_num = length(X);
weight_prior = ones(1,V_num);
for v=1:V_num
    NewDim{v} =20;  %---
    X{v}=mapminmax(X{v},0,1); %������ѹ����0,1֮��
%     X{v}=X{v}';
end
train_rate = 0.8;

[X_tr,Y_train,X_te,Y_test]=dataRandom_serious_football(X,Y,V_num,train_rate);
Y_train = Y_train';
Y_test = Y_test';

%�ڶ�������ѵ����������������
chit = 1;
cmiss = 1;
for v=1:V_num
    [a,b]=PPDpair(X_tr{v}',Y_train,chit,cmiss);%100������,YҪ1*100;XҪ100*4 
    zr{v}=a;
    yr{v}=b;
end

%��������׼��K
lamda=1;
for v=1:V_num
    st = cputime;
    Ktr{v}=KRR(X_tr{v}',yr{v},zr{v},lamda);%KRR�У�����ҪX_tr��4*135��135��������
    et = cputime-st;
    t(v)= et;
end


%���Ĳ���
fprintf('-------------Start generating data------------- \n');             

    K = V_num;
    X_task = cell(K,1);
    Y_task_total = yr';
    group_index_task = yr';
    weight_task = cell(K,1);
    for k=1:V_num
        X_task{k} = Ktr{k};      
    end
    gnd_Test = Y_test;
    numClasses = numclass;
    
    for i=1:K
       weight_task{i} = 1; 
    end

    lamdaa = 0.01;
    for k=1:V_num
        Q{k} = inv(lamdaa*eye(size(X_task{k},2))+X_task{k});
    end
    
    filename = ['data\tasks\football_6view1.mat'];
    save(filename, 'Q','Y_task_total','X_task','group_index_task','weight_task','numClasses','gnd_Test');
    
% end
fprintf('-------------End generating data------------- \n');   