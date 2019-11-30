clear;
datalist{1}='emotion';
datalist{4}='flags';
datalist{7}='imageTEXURE';


currentFolder = pwd;
addpath(genpath(currentFolder));
    

method='MLKRR';
data_select=[1 4 7];  
chit=4;
lambda=0.1;
 for i=1:length(data_select)
                    kk=data_select(i);
                    eval(['load ' [datalist{kk} '_train']])
                    eval(['load ' [datalist{kk} '_test']])
                    fprintf(datalist{kk});

                    % iindex{k,i}=fea_ind;
					
					 switch method
                               case 'MLKRR'
                                       M=MLMLKRR(train_data',train_target',chit,lambda); 
                                       %M=eye(size(train_data,2));
                                      [HammingLoss(i),RankingLoss(i),OneError(i),Coverage(i),Average_Precision(i)]=mlknn(train_data,train_target,test_data,test_target,M);
                     end
end
      
result=[HammingLoss',RankingLoss',OneError',Coverage',Average_Precision']
