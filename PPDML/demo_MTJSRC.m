

%%%%%%%%%%%%%%%%%%%%%% data prepare %%%%%%%%%%%%%%%%%%%%%%%%

tic;  
clear;
% [X_tr,Y_train,X_te,Y_test,zr,yr,V_num]=Data_Generation2;
% chit = 1;
% cmiss = 1;
% lambda=1;



    % 第一步：把原始数据拆成train和test
    load('/dataset/MSRA_6view.mat');
%     gt=Y;
    numclass = max(gt)-min(gt) + 1;
    V_num = length(X);
    weight_prior = ones(1,V_num);
    for v=1:V_num
        NewDim{v} =20;  %---
        X{v}=mapminmax(X{v},0,1); %将数据压缩到0,1之间
        X{v}=X{v}';
    end
    train_rate = 0.8;
    [X_tr,Y_train,X_te,Y_test]=dataRandom_serious_football(X,gt,V_num,train_rate);
    Y_train = Y_train';
    Y_test = Y_test';

    % 第二步：在训练集上生成样本对
    chit = 1;
    cmiss = 1;
    lambda=1;
    for v=1:V_num
        [a,b]=PPDpair(X_tr{v}',Y_train,chit,cmiss);%100个数据,Y要1*100;X要100*4 
        zr{v}=a;
        yr{v}=b;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    s = MTJSRC;

    for v=1:V_num
        ss = s{v};
        M = KRR2(X_tr{v}',zr{v},ss);
        dist = KRRML2(X_tr{v}',X_te{v}',Y_train,Y_test,chit,cmiss,lambda,M,zr{v},yr{v}); 
        distall{v}=dist;
    end
    for v=1:V_num
        tempdist=distall{v};
        [testSampleNum,~] = size(tempdist);
        predictLabels = zeros(1,testSampleNum);
        for j=1:testSampleNum

            dist = tempdist(j,:);
            [~,minindex]=mink(dist(:),chit);

             predictLabels(j)=mode(Y_train(minindex));
        end
        correctNum=length(find(predictLabels==Y_test));
        eccu_m=correctNum/testSampleNum*100;
        ecc(v) = eccu_m;
    end
    tempdist=distall{1};
    
    for v=2:V_num
       tempdist = tempdist + distall{v} ;
    end
    [testSampleNum,~] = size(tempdist);
    predictLabels = zeros(1,testSampleNum);
    for j=1:testSampleNum
      dist = tempdist(j,:);
      [~,minindex]=mink(dist(:),chit);

       predictLabels(j)=mode(Y_train(minindex));
    end
    correctNum=length(find(predictLabels==Y_test));
    accu_m=correctNum/testSampleNum*100;
    acc=accu_m;

% acc_mean=mean(accu_m)
% acc_std=std(accu_m)  
% result=[acc_mean',acc_std']; 
% result=result/100  
toc;