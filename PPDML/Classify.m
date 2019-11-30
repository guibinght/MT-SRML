function    predClass = Classify(Y, X, group_index, weight, W)

K = size(Y,1);

a_total = [];
for (i=unique(group_index{1}))

    c = [];
    d = [];
    for (k=1:K)
        cur_idx = find(group_index{k}'==i);
        W_temp = W{k}(cur_idx);
        c = [c; weight{k}*(-2*(Y{k}(cur_idx))'*W_temp+W_temp'*X{k}(cur_idx,cur_idx)*W_temp)];
        d = [d; weight{k}*sum(W_temp)];
    end    
    a = -sum(c);
    a_total = [a_total,a];
end

[drop, predClass] = max(a_total);
