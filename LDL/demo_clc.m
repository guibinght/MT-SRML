%  
%     clear;
datalist{1}='fgnet';

currentFolder = pwd;
addpath(genpath(currentFolder));

method='CKNN';
distanceMark='Ma';  
chit=5;
data_select=[1];

 for i=1:length(data_select)
                    kk=data_select(i);
                    eval(['load ' [datalist{kk}]])
                    fprintf(datalist{kk});

                    % iindex{k,i}=fea_ind;
					
					 switch method
                               case 'CKNN'
                                        M=MLML(tr_dat,trls',chit); 
                                       %M=eye(size(tr_dat,1));
                                       result=cknn(tr_dat',trls',tt_dat',ttls', 1, distanceMark,M)
                     end
end
      

