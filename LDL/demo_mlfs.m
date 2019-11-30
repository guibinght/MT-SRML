%  
%     clear;
    datalist{1}='emotion';
    datalist{2}='flags';
    datalist{3}='imageTEXURE';
    

currentFolder = pwd;
addpath(genpath(currentFolder));
    
method='MLKNN';
data_select=[1 2 3];  
chit=3;

 for i=1:length(data_select)
                    kk=data_select(i);
                    eval(['load ' [datalist{kk} '_train']])
                    eval(['load ' [datalist{kk} '_test']])
                    fprintf(datalist{kk});

                    % iindex{k,i}=fea_ind;
					
					 switch method
                               case 'MLKNN'
                                       M=MLML(train_data',train_target',chit); 
                                       %M=eye(size(train_data,2));
                                      [HammingLoss(i),RankingLoss(i),OneError(i),Coverage(i),Average_Precision(i)]=mlknn(train_data,train_target,test_data,test_target,M);
                     end
end
      
result=[HammingLoss',RankingLoss',OneError',Coverage',Average_Precision']
