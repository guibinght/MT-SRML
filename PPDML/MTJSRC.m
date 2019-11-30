function [W] = MTJSRC


fea_names = {'hog','hsv','siftint','siftbdy','colourgc','shapegc','ll'};%MSRA

fprintf('--------- Task (feature) confidence --------- \n');
a = size(fea_names,2);
weight_task=cell(a,1);
for (i=1:a)
    weight_task{i}=1;
end

for (i=1:size(fea_names,2))
    fprintf('%s : %f/7 \n', fea_names{i}, weight_task{i});
end

cr_rate = [];
% for (split_id =[1:1])

    load(['data\tasks\MSRA_6view1.mat']);
    
    fprintf('-------------train/test ------------- \n');
    fprintf('Number of test images processed: ');
        
    K = length(Q);
    
    
    for (l=1:1)
        
        Y_task = cell(K,1);
        for (k=1:K)
            Y_task{k} = Y_task_total{k}'; 
        end     
        
        %----------Joint sparse representation and classification---------------

        R = X_task;
        opt = [];
        
        opt.eta = 0.002;
        opt.lambda = 0.001;
        opt.ite_num = 5;
        opt.kernel_view = 1;
        
        W = MTJSRC_APG(X_task, Y_task, Q, group_index_task, opt);
    
    end  

