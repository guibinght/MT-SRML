% Data generation and preprocessing
%
% Author:: Xiao-Tong Yuan
%
% AUTORIGHTS
% Copyright (C) 2009-10 
% Learning & Vision Research Group, ECE,Dept. NUS
% Xiao-Tong Yuan (Dr.), eleyuanx@nus.edu.sg

clear all;

load('data\17_Similarity_Matrices\distancematrices17itfeat08.mat');
load('data\17_Similarity_Matrices\distancematrices17gcfeat06.mat');
fea_names = {'hog','hsv','siftint','siftbdy','colourgc','shapegc','texturegc'};
weight_prior = ones(3,7);
 
fprintf('-------------Start generating data------------- \n');             
for (l=1:3)
    load(['data\datasplits\datasplits_',int2str(l),'.mat']);
    
    fprintf('For train/test split #%d \n', l);
    
    gnd_Train = ceil(trn/80);
    gnd_Test = ceil(tst/80);
    
    fea_Train = [];
    fea_Test = [];
    
    for (j=1:size(fea_names,2))
        
       DM =  eval(['D_',fea_names{j}]);
       
       mu = 1/mean(mean(DM(trn,trn)));
       KM = exp(-mu*DM);
        
       fea_Train = [fea_Train; {KM(trn,trn)}];
       fea_Test = [fea_Test; {KM(trn,tst)}];
    end
   
    
    task_id = [1:size(fea_Train,1)];
    K = length(task_id);
    X_task = cell(K,1);
    Y_task = cell(K,1);
    Y_task_total = cell(K,1);
    group_index_task = cell(K,1);
    weight_task = cell(K,1);
    Q = cell(K,1);
    
    numClasses = length(unique(gnd_Train));
    
    for (k=1:K)
        
        weight_task{k} = weight_prior(l, k);  
        
        X_task{k} = fea_Train{task_id(k)};
        lamda = 0.01;
        Q{k} = inv(lamda*eye(size(X_task{k},2))+X_task{k});
        group_index_task{k} = gnd_Train;
        
        Y_task_total{k} = fea_Test{task_id(k)};
    end
    
    filename = ['..\data\tasks\task_',int2str(l),'.mat'];
    save(filename, 'Q','Y_task_total','X_task','group_index_task','weight_task','numClasses','gnd_Test');
    
end
fprintf('-------------End generating data------------- \n');   